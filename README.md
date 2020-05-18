# IPDR DOCKER image

## Topic

Propose a docker image for ipdr project [jvassev/image2ipfs](https://github.com/jvassev/image2ipfs)


## How to

```
# running server
docker run -d --name registry -p 5000:5000 josselinchevalay/ipdr

# push docker image to ipfs 
docker save my_image | docker exec -i registry image2ipfs

# pull on image
docker pull localhost:5000/<hash>/my_image
```

## Docker compose 

```
version: '3.1'
services:
   registry:
      image: josselinchevalay/ipdr
      volumes:
        - registry_ipfs_data:/home/astroport/.ipfs
      ports:
         - 5000:5000
         - 5001:5001
         - 4001:4001
         - 8080:8080

volumes:
   registry_ipfs_data:
```
