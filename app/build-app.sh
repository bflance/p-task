docker build -t my-app .
docker tag my-app localhost:5000/my-app
docker push localhost:5000/my-app