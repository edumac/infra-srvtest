docker network create net-eduardo
docker network connect --alias dlportal net-eduardo dlportal-80
docker network connect --alias giaweb   net-eduardo giaweb-81
:: docker network inspect dockernet