# Rush for Orion Context Broker
This container packs the [Rush relayer](https://github.com/telefonicaid/Rush) component for Orion.
To deploy Orion Context Broker with Rush, first create a network for Orion, Mongo and Rush:
```
sudo docker network create orion-net --opt=com.docker.network.driver.mtu=1400
```

Launch redis for rush:
```
sudo docker run --name redis-rush -network=orion-net -d redis redis-server --appendonly yes
```
Launch rush:
```
sudo docker run --name rush --network orion-net -d gradiant/rush
```
Launch Orion Context broker from the official repository:
```
sudo docker run --name mongo-orion -v $PWD/mongoDB:/data/db --network orion-net -d mongo:3.2
sudo docker run -d --name orion --network=orion-net -p 1026:1026 fiware/orion -rush rush:5001 -dbhost mongo-orion
```
