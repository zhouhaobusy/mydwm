#! /bin/bash
# dwm状态栏刷新脚本

source ~/.profile

s2d_reset="^d^"
s2d_fg="^c"
s2d_bg="^b"
color00="#2D1B46^"
color01="#223344^"
color02="#4E5173^"
color03="#333344^"
color04="#111199^"
color05="#442266^"
color06="#335566^"
color07="#334466^"
color08="#553388^"
color09="#CCCCCC^"


 others_color="$s2d_fg$color01$s2d_bg$color02"
    cpu_color="$s2d_fg$color00$s2d_bg$color06"
  d_cpu_color="$s2d_fg$color09$s2d_bg$color06"
    mem_color="$s2d_fg$color05$s2d_bg$color07"
  d_mem_color="$s2d_fg$color09$s2d_bg$color07"
   time_color="$s2d_fg$color00$s2d_bg$color06"
    vol_color="$s2d_fg$color00$s2d_bg$color07"
    bat_color="$s2d_fg$color00$s2d_bg$color02"

	temp_color_="$s2d_fg$color00$s2d_bg$color06"

print_others() {
    icons=()
    [ "$(docker ps | grep v2raya)" ] && icons=(${icons[@]} "")
    [ "$(bluetoothctl info 64:03:7F:7C:81:15 | grep 'Connected: yes')" ] && icons=(${icons[@]} "")
    [ "$(bluetoothctl info 8C:DE:F9:E6:E5:6B | grep 'Connected: yes')" ] && icons=(${icons[@]} "")
    [ "$(bluetoothctl info 88:C9:E8:14:2A:72 | grep 'Connected: yes')" ] && icons=(${icons[@]} "")

    [ "$(ps -aux | grep 'danmu_sender' | sed 1d)" ] && icons=(${icons[@]} "ﳲ")
    [ "$AUTOSCREEN" = "OFF" ]  && icons=(${icons[@]} "ﴸ")
	[ "$(ps -axf | pgrep wp-autochange)" ] && icons=(${icons[@]} "")

    if [ "$icons" ]; then
        text=" ${icons[@]} "
        color=$others_color
        printf "%s%s%s" "$color" "$text" "$s2d_reset"
    fi
}

print_baby() {
	boby_name="   "
	text=$symbol
	color=$temp_color_
    printf "%s%s%s" "$color" "$boby_name" "$s2d_reset"


}

print_temp() {
	temp_icon="糖"
	tmp_temp_text=$(cat /sys/class/thermal/thermal_zone0/temp)
	temp_text=$(($tmp_temp_text / 1000 ))
    text=" $temp_text$temp_icon "
	color=$temp_color_
	if [ "$temp_text" -ge 90 ]; then color=$temp_color_; prefix_icon="";
	elif [ "$temp_text" -ge 75 ]; then color=$temp_color_;prefix_icon="";
	elif [ "$temp_text" -ge 70 ]; then color=$temp_color_;prefix_icon="";
	elif [ "$temp_text" -ge 60 ]; then color=$temp_color_;prefix_icon="";
	elif [ "$temp_text" -ge 0 ]; then color=$temp_color_;prefix_icon="";
	else color=$temp_color_; fi
    printf "%s%s%s%s" "$color" " $prefix_icon" "$text" "$s2d_reset"

}

print_symbol(){
	symbol="  "
	text=$symbol
	color=$temp_color_
    printf "%s%s%s" "$color" "$text" "$s2d_reset"

}

print_cpu() {
    cpu_icon="閭"
    cpu_text=$(top -n 1 -b | sed -n '3p' | awk '{printf "%02d", 100 - $8}')

    if  [ "$cpu_text" -ge 90 ]; then light="━━━━━"; dark="";
    elif [ "$cpu_text" -ge 70 ]; then light="━━━━"; dark="━";
    elif [ "$cpu_text" -ge 50 ]; then light="━━━"; dark="━━";
    elif [ "$cpu_text" -ge 30 ]; then light="━━"; dark="━━━";
    elif [ "$cpu_text" -ge 10 ]; then light="━"; dark="━━━━";
    else light=""; dark="━━━━━"; fi

    cpu_text=$cpu_text%

    text1=" $cpu_icon $light"
    text2="$dark"
    text3=" $cpu_text "

    color1=$cpu_color
    color2=$d_cpu_color

    printf "%s%s%s" "$color1" "$text1" "$s2d_reset"
    printf "%s%s%s" "$color2" "$text2" "$s2d_reset"
    printf "%s%s%s" "$color1" "$text3" "$s2d_reset"
}

print_mem() {
	available=$(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}')
	total=$(grep -m1 'MemTotal:' /proc/meminfo | awk '{print $2}')
	mem_icon=""
    mem_text=$(echo $[ ($total - $available) * 100 / $total ] | awk '{printf "%02d", $1}')

    if  [ "$mem_text" -ge 90 ]; then light="━━━━━"; dark="";
    elif [ "$mem_text" -ge 70 ]; then light="━━━━"; dark="━";
    elif [ "$mem_text" -ge 50 ]; then light="━━━"; dark="━━";
    elif [ "$mem_text" -ge 30 ]; then light="━━"; dark="━━━";
    elif [ "$mem_text" -ge 10 ]; then light="━"; dark="━━━━";
    else light=""; dark="━━━━━"; fi

    mem_text=$mem_text%

    text1=" $mem_icon $light"
    text2="$dark"
    text3=" $mem_text "

    color1=$mem_color
    color2=$d_mem_color

    printf "%s%s%s" "$color1" "$text1" "$s2d_reset"
    printf "%s%s%s" "$color2" "$text2" "$s2d_reset"
    printf "%s%s%s" "$color1" "$text3" "$s2d_reset"
}

print_wifi() {
	# method 1
	# network_res="$(ping -c5 -i .1 www.baidu.com | grep packets | cut -d, -f3 | tr -d ' ' | cut -d% -f1)"
	network_res="$(ifconfig -v wlp4s0 | grep inet | grep -v inet6 | tr -s ' ' | cut -d ' ' -f3)"
	# if the network_res is null ,then the network is bad

	[ $network_res ] && network_res=0
    if  [ "$network_res" -eq 0 ]; then wifi_icon=" 直 ";
    else wifi_icon=" 睊 ";fi
	color=$temp_color_
    printf "%s%s%s" "$color" "$wifi_icon" "$s2d_reset"
}

print_time() {
    time_text="$(date '+%m/%d %H:%M')"
    case "$(date '+%I')" in
        "01") time_icon="" ;;
        "02") time_icon="" ;;
        "03") time_icon="" ;;
        "04") time_icon="" ;;
        "05") time_icon="" ;;
        "06") time_icon="" ;;
        "07") time_icon="" ;;
        "08") time_icon="" ;;
        "09") time_icon="" ;;
        "10") time_icon="" ;;
        "11") time_icon="" ;;
        "12") time_icon="" ;;
    esac

    text=" $time_icon $time_text "
    color=$time_color
    printf "%s%s%s" "$color" "$text" "$s2d_reset"
}

print_vol() {

    volunmuted=$(pactl list sinks  | grep 'Mute: no')
    vol_text=$(pactl list sinks | grep "Volume: front-left" | tr -d ' ' | cut -d'/' -f2 | tr -d '%')
    if [ "$vol_text" -eq 0 ] || [ ! "$volunmuted" ]; then vol_text="--"; vol_icon="婢";
    elif [ "$vol_text" -lt 10 ]; then vol_icon="奄"; vol_text=0$vol_text;
    elif [ "$vol_text" -le 20 ]; then vol_icon="奄";
    elif [ "$vol_text" -le 60 ]; then vol_icon="奔";
    else vol_icon="墳"; fi

    vol_text=$vol_text%

    text=" $vol_icon $vol_text "
    color=$vol_color
    printf "%s%s%s" "$color" "$text" "$s2d_reset"
}

print_bat() {
    bat_text=$(expr $(acpi -b | sed 2d | awk '{print $4}' | grep -Eo "[0-9]+"))
    [ ! "$(acpi -b | grep 'Battery 0' | grep Discharging)" ] && charge_icon=""
    if  [ "$bat_text" -ge 95 ]; then charge_icon=""; bat_icon="";
    elif [ "$bat_text" -ge 90 ]; then bat_icon="";
    elif [ "$bat_text" -ge 80 ]; then bat_icon="";
    elif [ "$bat_text" -ge 70 ]; then bat_icon="";
    elif [ "$bat_text" -ge 60 ]; then bat_icon="";
    elif [ "$bat_text" -ge 50 ]; then bat_icon="";
    elif [ "$bat_text" -ge 40 ]; then bat_icon="";
    elif [ "$bat_text" -ge 30 ]; then bat_icon="";
    elif [ "$bat_text" -ge 20 ]; then bat_icon="";
    elif [ "$bat_text" -ge 10 ]; then bat_icon="";
    else bat_icon=""; fi

    bat_text=$bat_text%
    bat_icon=$charge_icon$bat_icon

    text=" $bat_icon $bat_text "
    color=$bat_color
    printf "%s%s%s" "$color" "$text" "$s2d_reset"
}

xsetroot -name "$(print_symbol)$(print_others)$(print_cpu)$(print_mem)$(print_time)$(print_vol)$(print_wifi)$(print_temp)$(print_bat)"
