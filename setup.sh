#!/bin/bash

rose='\033[1;31m'
violetfonce='\033[0;35m'
violetclair='\033[1;35m'
neutre='\033[0m'
cyanfonce='\033[0;36m'
cyanclair='\033[1;36m'
vertfonce='\033[0;32m'
vertclair='\033[1;32m'
rouge='\033[31m'

# set -e

DOCKER_PATH=$PWD/srcs
NGINX_PATH=$PWD/srcs/nginx
DRIVER=docker

#sudo usermod -aG docker $USER && newgrp docker
#curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.9.0/minikube-linux-amd64 \
#  && chmod +x minikube
#echo "user42" | sudo -S mkdir -p /usr/local/bin ; echo "user42" | sudo -S install minikube /usr/local/bin/
# docker system prune -a
# kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml  configuration metallb
# kubectl apply -f srcs/configmap.yml
# minikube -p a mettre dans eval pour des instances multiples
# ssh-keygen -R 192.168.99.3
# docker stop $(docker ps -a -q) ; docker rm $(docker ps -a -q)     rm container
# CLUSTER_IP="$(kubectl get node -o=custom-columns='DATA:status.adresses[0].address' | sed -n 2p)"
apply_kustom ()
{
	echo "apply kusto"
	kubectl apply -f srcs/k8s
	sleep 10
	echo "kusto applied"
}

image_build ()
{
	eval $(minikube -p minikube docker-env)
	# sed s/__MINIKUBEIP__/$(minikube ip)/g < srcs/telegraf/telegraf_generic.conf > srcs/telegraf/telegraf.conf
	docker build $DOCKER_PATH/nginx -t ft_nginx
	docker build $DOCKER_PATH/mysql -t ft_mysql
	docker build $DOCKER_PATH/phpmyadmin -t ft_phpmyadmin
	docker build $DOCKER_PATH/wordpress -t ft_wordpress
	docker build $DOCKER_PATH/telegraf -t ft_telegraf
	docker build $DOCKER_PATH/influxdb -t ft_influxdb
	docker build $DOCKER_PATH/grafana -t ft_grafana
	docker build $DOCKER_PATH/ftps -t ft_ftps
}

start ()
{
	# minikube config set vm-driver virtualbox
	minikube config unset vm-driver
	minikube start --driver=$DRIVER > /dev/null
	sleep 10
	eval $(minikube -p minikube docker-env)
	kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
	/bin/echo "Launching minikube"
	# minikube dashboard > dashboard_logs &
	image_build
	apply_kustom
}

ip ()
{
	minikube ip;
}

clear ()
{
	kubectl delete --all deployments
	kubectl delete --all pods
	kubectl delete --all services
	kubectl delete --all pvc
}

clear_one ()
{
	var=$(kubectl get pods -o=name | grep "^pod/$2" | sed 's/^pod\///')
	kubectl delete pod $var || true
	kubectl delete service $2 || true
	kubectl delete deployment $2 || true
}

do_refresh ()
{
	clear_one $1 $2
	eval $(minikube -p minikube docker-env)
	docker build $DOCKER_PATH/$2 -t ft_$2
	kubectl apply -f srcs/k8s/$2.yaml
}

refresh_one ()
{
	echo $2
	case $2 in
		"all")
		clear
		image_build
		apply_kustom
		;;
		"nginx")
			do_refresh $1 $2
			;;
		"mysql")
			do_refresh $1 $2
			;;
		"wordpress")
			do_refresh $1 $2
			;;
		"phpmyadmin")
			do_refresh $1 $2
			;;
		"ftps")
			do_refresh $1 $2
			;;
		"influxdb")
			do_refresh $1 $2
			;;
		"telegraf")
			do_refresh $1 $2
			;;
		"grafana")
			do_refresh $1 $2
			;;
		*)
	esac
}

virgin ()
{
	minikube delete
	echo "user42" | sudo -S rm -rf /usr/local/bin/minikube
	echo "Download minikube"
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/v1.9.0/minikube-linux-amd64 \
	&& chmod +x minikube
	echo "user42" | sudo -S mkdir -p /usr/local/bin ; echo "user42" | sudo -S install minikube /usr/local/bin/
	rm minikube
	kubectl delete
	echo "user42" | sudo -S rm -rf /usr/local/bin/kubectl
	echo "Download Kubectl"
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl \
	&& chmod +x ./kubectl
	echo "user42" | sudo -S mkdir -p /usr/local/bin ; echo "user42" | sudo -S install kubectl /usr/local/bin/
	rm kubectl
}

if [ "$1" = "stop" ]; then
	kubectl delete -f srcs/k8s
	minikube stop;
elif [ "$1" = "list" ]; then
	minikube service list;
	ip;
elif [ "$1" = "update" ]; then
	kubectl delete all --all
	image_build
	apply_kustom
	ip;
elif [ "$1" = "apply" ]; then
	apply_kustom
	ip;
elif [ "$1" = "reapply" ]; then
	clear || true
	image_build || true
	apply_kustom || true
	minikube service list || true
	ip || true;
elif [ "$1" = "build" ]; then
	image_build;
elif [ "$1" = "env" ]; then
	echo "eval $(minikube docker-env)"
elif [ "$1" = "ip" ]; then
	ip;
elif [ "$1" = "clean" ]; then
	minikube delete;
elif [ "$1" = "open" ]; then
	enter;
elif [ "$1" = "restart" ]; then
	clear
	minikube delete;
	var=$(minikube status | wc -l);
	echo "$var";
	start;
elif [ "$1" = "refresh" ]; then
	refresh_one $1 $2;
elif [ "$1" = "virgin" ]; then
	virgin;
	start;
elif [ !$1 ]; then
	start;
fi
