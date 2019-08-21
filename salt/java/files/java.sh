{%- from "java/map.jinja" import environment with context %}

JAVA_HOME={{ environment.java_home }}
PATH=$HOME/bin:$JAVA_HOME/bin:$PATH

#JRE_HOME={{ environment.java_home }}
#PATH=$PATH:$HOME/bin:$JRE_HOME/bin

export JAVA_HOME
#export JRE_HOME
export PATH
