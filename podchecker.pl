#!/usr/bin/env perl
use strict;
use warnings;

# Script: podchecker.pl
# Purpose: Send a daily email reminder to scan a portion of the podcast list.
# Author: Automated generation
#
# This script chooses a letter of the alphabet based on the number of days
# since the Unix epoch and sends an email reminder to check podcasts starting
# with that letter.

use POSIX qw(strftime);

# Recipient details
my $recipient = 'David Vergin <dvergin\@fastmail.net>';

# Array of letter choices (A-Z)
my @init_strs = (
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
);

# Determine the current day count since the Unix epoch (1970-01-01)
my $days_since_epoch = int(time / 86_400);

# Pick the letter based on the day count
my $index = $days_since_epoch % scalar(@init_strs);
my $letter = $init_strs[$index];

# Format the date for display in the subject
my $date_str = strftime('%Y-%m-%d', localtime);

my $subject = "Podcast Review Reminder for $date_str";

my $body = "Hi David,\n\n" .
            "Please scan your podcast list and review shows starting with the letter '$letter'.\n" .
            "Remove any dead or uninteresting podcasts you find.\n\n" .
            "Thanks.\n";

# Send the email using sendmail
open(my $mail, '|-', '/usr/sbin/sendmail -t') or die "Could not open sendmail: $!";
print $mail "To: $recipient\n";
print $mail "Subject: $subject\n";
print $mail "Content-Type: text/plain; charset=\"UTF-8\"\n\n";
print $mail $body;
close($mail) or warn "sendmail exit status: $?";

exit 0;
