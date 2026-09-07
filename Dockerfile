FROM nginx:alpine
RUN echo '<!DOCTYPE html><html><head><title>Auto-Healing Web Tier</title></head><body><h1 style="text-align:center; margin-top:20%;">Auto-Healing NGINX Tier Active</h1></body></html>' > /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
