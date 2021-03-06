# add PATH for dotfiles project
#if [ -d "~/Projects/dotfiles/bin" ] ; then
#    PATH="$PATH"
#fi

nodename=`uname -n`

# my JAVA stuff
if [ $nodename = "marcoz-desktop" ]; then
  # desktop @ BC

  export JDK6_HOME="/opt/Java/jdk1.6.0_45"
  export JDK7_HOME="/opt/Java/jdk1.7.0_80"
  export JDK8_HOME="/opt/Java/jdk1.8.0_112"

  export JDK_HOME=$JDK8_HOME
  export MAVEN_HOME="/opt/Maven/apache-maven-3.3.9"
  arch="amd64"

  NODE_JS_HOME=/opt/NodeJS/node-v4.4.1-linux-x64
elif [ $nodename = "castle" ]; then
  # notebook

  export JDK6_HOME="/opt/Java/jdk1.6.0_45"
  export JDK7_HOME="/opt/Java/jdk1.7.0_80"
  export JDK8_HOME="/opt/Java/jdk1.8.0_112"

  export JDK_HOME=$JDK8_HOME
  export MAVEN_HOME="/opt/Maven/apache-maven-3.3.9"
  arch="i386"

  NODE_JS_HOME=/opt/NodeJS/node-v4.4.1-linux-x86
fi

export JAVA_HOME=$JDK_HOME

export M2_HOME=$MAVEN_HOME
export MAVEN_OPTS="-Xms128m -Xmx1024m"

export PATH="~/Projects/dotfiles/bin:/opt/bin:$JAVA_HOME/bin:$MAVEN_HOME/bin:$NODE_JS_HOME/bin:$PATH"

# for firefox
MOZILLA_HOME=~/.mozilla
mkdir -p $MOZILLA_HOME/plugins
ln -s -f $JDK8_HOME/jre/lib/$arch/libnpjp2.so $MOZILLA_HOME/plugins

# seadas config
#source ~/Projects/BC/Calvados/cdt_ws/config/seadas.env
