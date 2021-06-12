#!/bin/bash
#Version 1.0.0

#xset_cmd='/usr/bin/xset'
vcgen_cmd='/usr/bin/vcgencmd'
cut_cmd='/usr/bin/cut'
sleep_cmd='/usr/bin/sleep'
mqttpub_cmd='/usr/bin/mosquitto_pub'
#grep_cmd='/usr/bin/grep'

#vcgencmd outputs display_power=0 for off and =1 for on
function is_off() {
  result=`$vcgen_cmd display_power |$cut_cmd -d= -f2`
  return $result
}

if is_off
then
  #turn on
  $vcgen_cmd display_power 1
  $mqttpub_cmd -t frame/state -m on -q 0 -r

  # delay & restart monior process to prevent accidental multi touches from queueing
  $sleep_cmd 1
  systemctl --user restart touch-monitor

else
  #turn off
  $vcgen_cmd display_power 0
  $mqttpub_cmd -t frame/state -m off -q 0 -r

  # delay & restart monior process to prevent accidental multi touches from queueing
  $sleep_cmd 1
  systemctl --user restart touch-monitor

fi
