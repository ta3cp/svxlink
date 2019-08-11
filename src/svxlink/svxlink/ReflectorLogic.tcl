###############################################################################
#
# ReflectorLogic event handlers
#
###############################################################################

#
# This is the namespace in which all functions below will exist. The name
# must match the corresponding section "[ReflectorLogic]" in the configuration
# file. The name may be changed but it must be changed in both places.
#
namespace eval ReflectorLogic {

# The currently selected TG. Variable set from application.
variable selected_tg 0

# The previously selected TG. Variable set from application.
variable previous_tg 0

# Timestamp for previous TG announcement
variable prev_announce_time 0

# The previously announced TG
variable prev_announce_tg 0

#
# Checking to see if this is the correct logic core
#
if {$logic_name != [namespace tail [namespace current]]} {
  return;
}


#
# Executed when manual TG announcement is triggered
#
proc report_tg_status {} {
  variable selected_tg
  variable previous_tg
  variable prev_announce_time
  variable prev_announce_tg
  playSilence 100
  if {$selected_tg > 0} {
    set prev_announce_time [clock seconds]
    set prev_announce_tg $selected_tg
    playMsg "Core" "talk_group"
    spellNumber $selected_tg
  } else {
    playMsg "Core" "previous"
    playMsg "Core" "talk_group"
    spellNumber $previous_tg
  }
}


#
# Executed when a TG has been selected due to local activity
#
#   new_tg -- The talk group that has been activated
#   old_tg -- The talk group that was active
#
proc tg_local_activation {new_tg old_tg} {
  variable prev_announce_time
  variable prev_announce_tg
  variable selected_tg

  #puts "### tg_local_activation"
  if {$new_tg != $old_tg} {
    set prev_announce_time [clock seconds]
    set prev_announce_tg $new_tg
    playSilence 100
    playMsg "Core" "talk_group"
    spellNumber $new_tg
  }
}


#
# Executed when a TG has been selected due to remote activity
#
#   new_tg -- The talk group that has been activated
#   old_tg -- The talk group that was active
#
proc tg_remote_activation {new_tg old_tg} {
  variable prev_announce_time
  variable prev_announce_tg

  #puts "### tg_remote_activation"
  set now [clock seconds];
  if {($new_tg == $prev_announce_tg) && ($now - $prev_announce_time < 120)} {
    return;
  }
  if {$new_tg != $old_tg} {
    set prev_announce_time $now
    set prev_announce_tg $new_tg
    playSilence 100
    playMsg "Core" "talk_group"
    spellNumber $new_tg
  }
}


#
# Executed when a TG has been selected by DTMF command
#
#   new_tg -- The talk group that has been activated
#   old_tg -- The talk group that was active
#
proc tg_command_activation {new_tg old_tg} {
  variable prev_announce_time
  variable prev_announce_tg

  #puts "### tg_command_activation"
  set prev_announce_time [clock seconds]
  set prev_announce_tg $new_tg
  playSilence 100
  playMsg "Core" "talk_group"
  spellNumber $new_tg
}


#
# Executed when a TG has been selected due to DEFAULT_TG configuration
#
#   new_tg -- The talk group that has been activated
#   old_tg -- The talk group that was active
#
proc tg_default_activation {new_tg old_tg} {
  #variable prev_announce_time
  #variable prev_announce_tg
  #variable selected_tg
  #puts "### tg_default_activation"
  #if {$new_tg != $old_tg} {
  #  set prev_announce_time [clock seconds]
  #  set prev_announce_tg $new_tg
  #  playSilence 100
  #  playMsg "Core" "talk_group"
  #  spellNumber $new_tg
  #}
}


#
# Executed when a TG selection has timed out
#
#   new_tg -- Always 0
#   old_tg -- The talk group that was active
#
proc tg_selection_timeout {new_tg old_tg} {
  #puts "### tg_selection_timeout"
}


#
# Executed when an entered DTMF command failed
#
proc command_failed {cmd} {
  Logic::command_failed $cmd;
}


# end of namespace
}


#
# This file has not been truncated
#
