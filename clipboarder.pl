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
		warn "Pasting\n";
		paste($self);

		return 1; # ignore XEvent
	} 
	if($keysym eq 99 && $event->{state} & urxvt::Mod1Mask) {
		# press [alt]+c]
		warn "Copying\n";
		copy($self);

		return 1; # Ignore XEvent
	}

	()
}


sub paste {
	my ($self) = @_;

	my $content = `xsel -ob`;
	chomp($content);
	$self->tt_paste($content);

	()
}

sub copy {
	my ($self) = @_;

	my $content = $self->selection;
	system('echo "' . $content . '" | xsel -ib');

	()
}
