# requires xsel

sub on_start {
	my ($self, $search) = @_;

	$self->enable(key_press => \&key_press);
}

sub key_press {
	my ($self, $event, $keysym, $octets) = @_;

#	warn "Keypress: " . $octets . " " . $keysym . "\n";

 	if($keysym eq 118 && $event->{state} & urxvt::Mod1Mask) {
		# press [alt]+v]
		paste($self);

		return 1; # ignore XEvent
	} 
	if($keysym eq 99 && $event->{state} & urxvt::Mod1Mask) {
		# press [alt]+c]
		copy($self);

		return 1; # Ignore XEvent
	}

	()
}

sub paste {
	my ($self) = @_;

	my $str = `xsel -ob`;
	my $content = unescape($str);
	chomp($content);
	$self->tt_paste($content);

	()
}

sub copy {
	my ($self) = @_;

	my $content = escape($self->selection);
	system('echo "' . $content . '" | xsel -ib');

	()
}

sub escape {
	my ($str) = @_;

	$str =~ s/\\$/\\ /g;
	$str =~ s/"/\\"/g;

	return $str;
}

sub unescape {
	my ($str) = @_;

	$str =~ s/\\"/"/g;
	$str =~ s/\\ $/\\/g; # TODO: don't always replace them

	return $str;
}

sub at {
	my ($str, $index) = @_;
	return substr($str, $index - 1, 1);
}