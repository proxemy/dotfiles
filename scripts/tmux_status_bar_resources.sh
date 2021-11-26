#!/usr/bin/env sh

read -r cpu_usage ram_usage <<<$(
	top -p0 -bn 1 |
	awk '{
		if(NR==3) { printf int(100 - $8); printf " " }
		if(NR==4) printf int($6 * 100 / $4)
}')

case 1 in
	$(($cpu_usage >= 90)) )cpu_c="#[fg=white,bold,bg=red,blink]";;
	$(($cpu_usage >= 60)) )cpu_c="#[fg=white,bold,bg=yellow]";;
	*) cpu_c="#[fg=green]"
esac

case 1 in
	$(($ram_usage >= 85)) )ram_c="#[fg=white,bold,bg=red,blink]";;
	$(($ram_usage >= 70)) )ram_c="#[fg=white,bold,bg=yellow]";;
	*) ram_c="#[fg=green]"
esac

echo \
	$cpu_c"C%"$cpu_usage"#[default]" \
	$ram_c"R%"$ram_usage"#[default]" \
	"#[fg=yellow,dim]$(date +'%-jd %-H:%M' -d @`cut -d" " -f1 /proc/uptime`)"
