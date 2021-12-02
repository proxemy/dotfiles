NR == 3 {
	cpu_usage = int(100 - $8);
	if      (cpu_usage >= 90) cpu_c="#[fg=white,bold,bg=red,blink]";
	else if (cpu_usage >= 60) cpu_c="#[fg=white,bold,bg=yellow]";
	else                      cpu_c="#[fg=green]";
	printf(cpu_c"C%"cpu_usage"#[default] ");
}
NR == 4 {
	ram_usage = int($8 / $4 * 100);
	if      (ram_usage >= 85) ram_c="#[fg=white,bold,bg=red,blink]";
	else if (ram_usage >= 70) ram_c="#[fg=white,bold,bg=yellow]";
	else                      ram_c="#[fg=green]";
	printf(ram_c"R%"ram_usage"#[default] ");
}
NR > 4 { exit; }
END {
	getline < "/proc/uptime"; # overwrites $0 from orig stdin (gnutop)
	printf(\
		"#[fg=yellow,dim]%s%d:%02d:%02d",\
		($1/60/60/24 <= 0 ? int($1/60/60/24)":" : ""),\
		($1/60/60%24),\
		$1/60%60,\
		$1%60,\
		"#[default] "\
	);
}
