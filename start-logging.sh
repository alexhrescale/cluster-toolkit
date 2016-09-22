## RESOURCE LOGGER
INTERVAL=3

MEMORY_LOG=memory.log
MEMORY_LOCK=memory.lock

UPTIME_LOG=uptime.log
UPTIME_LOCK=uptime.lock

PROCESS_LOG=process.log
PROCESS_LOCK=process.lock

# memory
while true; do
  if [ -f $MEMORY_LOCK ]; then
    rm $MEMORY_LOCK
    break
  fi
  if [ ! -f $MEMORY_LOG ]; then
    echo `date` `free -m | head -1` >> $MEMORY_LOG
  fi
  echo `date` `free -m | head -2 | tail -n 1` >> $MEMORY_LOG
  sleep $INTERVAL;
done &

# uptime
while true; do
  if [ -f $UPTIME_LOCK ]; then
    rm $UPTIME_LOCK
    break
  fi
  uptime >> $UPTIME_LOG
  sleep $INTERVAL
done &

# ps
while true; do
  if [ -f $PROCESS_LOCK ]; then
    rm $PROCESS_LOCK
    break
  fi
  (echo "%CPU %MEM ARGS $(date)" && ps -e -o pcpu,pmem,args --sort=pcpu | cut -d" " -f1-5 | tail) >> $PROCESS_LOG
  sleep $INTERVAL
done &

