FROM ruby:2.1.10
RUN gem install selenium-webdriver && echo 'deb http://mozilla.debian.net/ jessie-backports firefox-release' > /etc/apt/sources.list.d/debian-mozilla.list \
&& apt-get update -y \
&& wget mozilla.debian.net/pkg-mozilla-archive-keyring_1.1_all.deb \
&& dpkg -i pkg-mozilla-archive-keyring_1.1_all.deb \
&& apt-get install -t jessie-backports firefox -y --force-yes \
&& wget https://github.com/mozilla/geckodriver/releases/download/v0.16.1/geckodriver-v0.16.1-linux64.tar.gz \
&& tar -xvzf geckodriver-v0.16.1-linux64.tar.gz \
&& rm geckodriver-v0.16.1-linux64.tar.gz \
&& chmod +x geckodriver \
&& cp geckodriver /usr/local/bin \
&& apt-get install xvfb -y \
&& gem install headless 
