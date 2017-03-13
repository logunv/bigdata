#
# Hadoop shell for beginners
#

error()
{
  echo Error: $*
}

if [ "$HADOOP_HOME" = "" ]; then
  error Environment variable HADOOP_HOME is not set.\
        Please set it and try again.
  exit 1
else
  if [ ! -f $HADOOP_HOME/sbin/start-dfs.sh ]; then
    error Hadoop install is missing at $HADOOP_HOME
    exit 1
  fi
fi

unset CDPATH
. $HADOOP_HOME/etc/hadoop/hadoop-env.sh 
use=fs

todo()
{
   echo TBD: $*
}

#todo ls with no args use "/"
#todo cd and pwd

showHelp()
{
    cat <<!
Available commands are:
----------
menu - show a menu
use - use a hadoop command
start - start hadoop
stop - stop hadoop
? - show help for this tool
q - quit
----------
!
}

showUseHelp()
{
cat <<!
Use options are:
----------------
fs
jar
checknative
archive
classpath
credential
daemonlog
trace
----------------
!

}


warn()
{
  echo Warn: $*
}




menu()
{
  while :
  do
    cat<<!
0. return from this menu
1. start hadoop services
2. stop hadoop services

!
    read -p ' > ' opt
    case $opt in
    0)
      return
      ;;
    1)
      startHadoop
      ;;
    2)
      stopHadoop
      ;;
    *)
      error Wrong option selected: $opt
      ;;
    esac
  done

}

startHadoop()
{
  $HADOOP_HOME/sbin/start-dfs.sh 
  $HADOOP_HOME/sbin/start-yarn.sh
}

stopHadoop()
{
  $HADOOP_HOME/sbin/stop-yarn.sh
  $HADOOP_HOME/sbin/stop-dfs.sh 
}

showExamples()
{
  cat <<!

1. To list the files in HDFS
use fs
ls -R /

2. To view the files in HDFS
use fs
cat /user/logu/datafile.txt

!
}

main()
{
  if [ $# -gt 0 ]; then
    use=$1
  fi

  while :
  do
    read -p "h:$use> " cmd

    if [ "$cmd" = "" ]; then
      continue
    fi

    if [ "$cmd" = "q" ]; then
      break
    fi

    cmd1=`echo $cmd | cut -d' ' -f1`
    case $cmd1 in
    \?)
      showHelp
      ;;
    examples)
      showExamples
      ;;
    start)
      startHadoop
      ;;
    stop)
      stopHadoop
      ;;
    use)
      use=`echo $cmd|cut -d' ' -f2`
      if [ "$use" = "-help" ]; then
        showUseHelp
      fi
      ;;
    menu)
      menu
      ;;
    *)
      $HADOOP_HOME/bin/hadoop $use -$cmd
      ;;
    esac
  done
}

# usage: hadoop default-command
main $*

