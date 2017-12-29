FROM nginx:1.13.8-alpine

MAINTAINER xergioalex@gmail.com

# Create logs files
RUN mkdir -p /etc/nginx/logs && \
	touch /etc/nginx/logs/site.access && \
	touch /etc/nginx/logs/site.error

# Copy custom configuration files
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# Run nginx
CMD nginx -g 'daemon off;'
