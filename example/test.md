!set{:theme="mytheme"}

!slide
{:class="one two title" title="foo bar slide"}

# Slidize theme tester

## It's really comprehensive!

!slide{:class="image"}

# This is an image

!slide{: class="inline"}

# Blockquote

The following text is a block quote:

> blah blah blah
> blah blah
> blah
>
> blah!
>
> Some more blah here! Lorem ipsum dolor sit amet etcetera.

!slide

# Heading 1

## Heading 2

### Heading 3

#### Heading 4

##### Heading 5

###### Heading 6

!slide

# Heading 1

## Heading 2

Text

### Heading 3

Text

#### Heading 4

Text

##### Heading 5

Text

###### Heading 6

!slide
{:class="many more classes"}

# Unordered lists (1/2)

Plain list:

* Foo
* This is a really long item which should span multiple lines. Bla bla blah blah!
* Baz
* Quux
^
* Bacon
* Beans

!slide

# Unordered lists (2/2)

Paragraphed list:

* Foo

* This is a really long item which should span multiple lines. Bla bla blah blah!

* Baz

* Quux

!slide

# Ordered lists (1/2)

Plain list:

1. Foo
2. This is a really long item which should span multiple lines. Bla bla blah blah!
3. Baz
4. Quux
^
1. Bacon
2. Beans

!slide

# Ordered lists (2/2)

Paragraphed list:

1. Foo

2. This is a really long item which should span multiple lines. Bla bla blah blah!

3. Baz

4. Quux

!slide

# Nested lists

* Foo
  * Sub 1
  * Sub 2
* Bar
* Baz
  1. Sub 1
  2. Sub 2
* Quux
^
1. This
   * Is
     * A
       1. Really
          * Deep
            * Nesting
              1. Example

!slide

# Definition lists

single term
: definition one
: definition two

first term
second term
: definition one
: definition two

another term

: with paragraphs
: without paragraphs

!slide

# Tables (1/2)

Simple example:

| Top left | Top right |
| Mid left | Mid right |
| Bottom left | Bottom right |

!slide

# Tables (2/2)

More complex example:

| Heading 1 | Heading 2 | Heading 3 |
|:---------:|:----------|----------:|
| Centered | Left aligned | Right aligned |
| More content | Even more content | another cell |
|-----------------------------------|
| Centered | Left aligned | Right aligned |
| More content | Even more content | another cell |
|===================================|
| Footer 1 | Footer 2 | Footer 3 |

!slide

# Custom HTML

<p><strong>This <em>is</em></strong> some <em>custom</em> <u>html</u> <strike>code</strike></p>

!slide

# Span-level elements

Plain *emphasized*, **strong**, [hyperlink](http://www.google.com/ "title"), `inline code`.

!slide
{:class="many more classes"}

# Code blocks

~~~
def foo
  bar = { :key => value }
  [ 1, 2, 3, 4, "coffee" ]
end
~~~
{:lang="ruby"}

!slide{:.title}

# That's all, folks.
