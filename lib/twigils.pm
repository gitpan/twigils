package twigils;
BEGIN {
  $twigils::AUTHORITY = 'cpan:FLORA';
}
{
  $twigils::VERSION = '0.01'; # TRIAL
}
# ABSTRACT: Perl 6 style twigils for Perl 5

require 5.014;
use strict;
use warnings;
use XSLoader;
use Carp 'croak';
use Devel::CallChecker;
use Devel::CallParser;
use Exporter 'import';

our @EXPORT = map { "intro_twigil_${_}_var" } qw(my state our);


sub intro_twigil_my_var {
    croak "intro_twigil_my_var called as a function";
}


sub intro_twigil_state_var {
    croak "intro_twigil_state_var called as a function";
}


sub intro_twigil_our_var {
    croak "intro_twigil_our_var called as a function";
}

XSLoader::load(
    __PACKAGE__,
    exists $twigil::{VERSION} ? ${ $twigil::{VERSION} } : (),
);

sub _add_allowed_twigil {
    my ($twigil) = @_;

    my %h = map {
        ($_ => 1)
    } (split '', $^H{ __PACKAGE__ . '/twigils' } || '');

    $^H{__PACKAGE__ . '/twigils'} = join '' => $twigil, keys %h;
}


1;

__END__

=pod

=encoding utf-8

=head1 NAME

twigils - Perl 6 style twigils for Perl 5

=head1 SYNOPSIS

    use twigils;

    intro_twigil_my_var $!foo;

    $!foo = 42;

    say $!foo;

=head1 DESCRIPTION

This module implements Perl 6 style twigils for Perl 5.

Twigils are similar to Perl's sigils (C<$>, C<@>, and C<%>, most importantly),
but consist of two characters. This module doesn't give any particular meaning
to any twigils and leaves that as the user's responsibility.

=head1 FUNCTIONS

=head2 intro_twigil_my_var $varname

  intro_twigil_my_var $!foo;

Introduces a new lexical twigil variable. Similar to perl's built-in C<my>
keyword.

=head2 intro_twigil_state_var $varname

  intro_twigil_state_var $!foo;

Introduces a new lexical twigil state variable. Similar to perl's built-in
C<state> keyword.

=head2 intro_twigil_our_var $varname

  intro_twigil_our_var $!foo;

Introduces a new lexical twigil variable as an alias to a package
variable. Similar to perl's built-in C<our> keyword.

=head1 WARNING

This is a B<ALPHA> release made mostly to make it easier for the p5-mop project
to experiment with using twigils. I don't recommend anyone using this module for
production code. See also: L</CAVEATS>.

=head1 CAVEATS

=over 4

=item *

Special punctuation variables and alphanumeric infix operators

Code such as C<$.eq 42> would normally be interpreted as comparing the contents
of the special variable C<$.> with the constant C<42> using the C<eq> infix
operator. However, in the presence of a twigil variable who's name consists of a
special variable name followed by the name of an infix operator (e.g. C<$.eq>)
an expression like C<$.eq 42> will be interpreted as a lookup of the variable
C<$.eq> followed by a constant C<42>, which will result in a syntax error. To
disambiguate between these two possible interpretations, use extra whitespace
between the special variable and the infix operator, i.e. C<$. eq 42>.

=item *

Spaces between twigil and the variable identifier are forbidden

As a consequence of the above caveat, it's not possible to use any whitespace
between the twigil and the variable identifier, as is possible with perls
built-in lexical variables: C<$ foo> references the variable C<$foo>. C<$!  foo>
will most likely cause a compile time error.

=item *

Long-hand dereferencing syntax is required

When storing references in twigil variables, the long-hand circumfix
dereferencing notation has to be used. C<@$!foo> doesn't cause the twigil
variable C<$!foo> to be dereferenced as an array. C<@{ $!foo }>, however, does.

=item *

Issues when interpolating in strings

Interpolating twigil variables in strings, such as in
C<my $str = "foo: $.foo";>, currently only works reliably for plain scalar
twigil variables. Interpolating twigil arrays will not work as expected when
trying to interpolate the entire array, a slice of the array, or even just a
single element of it. Postfix dereferencing, such as
C<my $str = "$.hash_ref->{foo}"> isn't currently supported either.

=back

=head1 AUTHOR

Florian Ragwitz <rafl@debian.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Florian Ragwitz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
