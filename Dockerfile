FROM node:0.12.7
# replace this with your application's default port
EXPOSE 3000

RUN mkdir -p /var/www/discogs-list-widget
WORKDIR /var/www/discogs-list-widget

RUN mkdir -p /root/.ssh
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN git clone https://github.com/mrlarner/discogs-list-widget.git /var/www/discogs-list-widget

RUN npm install

ADD bootstrap.sh /root/bootstrap.sh
CMD ["/root/bootstrap.sh"]


