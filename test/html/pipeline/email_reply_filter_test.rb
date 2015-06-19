# coding: utf-8
require "test_helper"

EmailReplyFilter = HTML::Pipeline::EmailReplyFilter

class HTML::Pipeline::EmailReplyFilterTest < Minitest::Test
  def setup
    @haiku =
      "Pointing at the moon\n" +
      "Reminded of simple things\n" +
      "Moments matter most"
    @links =
      "See http://example.org/ for more info"
    @code =
      "```\n" +
      "def hello()" +
      "  'world'" +
      "end" +
      "```"
  end

  def test_indent_after_quote
    body = <<EOF
On Thu, Jun 18, 2015 at 02:22:03PM -0700, Juan Batiz-Benet wrote:
> Though I think we want `ipfs id` to continue showing a bunch of
> information by default, and make the "only the peer id" an optional
> behavior…

I think it would be nice to have the final command (e.g. ‘id’ here, or
‘publish’ in ‘ipfs name publish’) be either the action you want to
take or the data you want to get back.  So if ‘ipfs id …’ is about
“give me a bunch of information about <peer>”, maybe it should be
‘ipfs peer …’.  Then we could have:

  $ ipfs peer --id
  QmbBHw1Xx9pUpAbrVZUKTPL5Rsph5Q9GQhRvcWVBPFgGtC

as a shortcut for:

  $ ipfs peer --format='<id>'
  QmbBHw1Xx9pUpAbrVZUKTPL5Rsph5Q9GQhRvcWVBPFgGtC

On the other hand, renames like this need an annoying multi-step
migration with a deprecation period, etc., so we'd want to do our best
to think through the indended UI to avoid further renames in the
coming months.  But we are talking about breaking the default output,
so maybe now is the time for that rename?
EOF
    expected = <<EOF
<div class=\"email-quoted-reply\">On Thu, Jun 18, 2015 at 02:22:03PM -0700, Juan Batiz-Benet wrote:
 Though I think we want `ipfs id` to continue showing a bunch of
 information by default, and make the &quot;only the peer id&quot; an optional
 behavior…</div>
<div class=\"email-fragment\">I think it would be nice to have the final command (e.g. ‘id’ here, or
‘publish’ in ‘ipfs name publish’) be either the action you want to
take or the data you want to get back.  So if ‘ipfs id …’ is about
“give me a bunch of information about &lt;peer&gt;”, maybe it should be
‘ipfs peer …’.  Then we could have:

  $ ipfs peer --id
  QmbBHw1Xx9pUpAbrVZUKTPL5Rsph5Q9GQhRvcWVBPFgGtC

as a shortcut for:

  $ ipfs peer --format=&#39;&lt;id&gt;&#39;
  QmbBHw1Xx9pUpAbrVZUKTPL5Rsph5Q9GQhRvcWVBPFgGtC

On the other hand, renames like this need an annoying multi-step
migration with a deprecation period, etc., so we&#39;d want to do our best
to think through the indended UI to avoid further renames in the
coming months.  But we are talking about breaking the default output,
so maybe now is the time for that rename?</div>
EOF
    seen_live = <<EOF
<div class="email-quoted-reply">On Thu, Jun 18, 2015 at 02:22:03PM -0700, Juan Batiz-Benet wrote:
 Though I think we want `ipfs id` to continue showing a bunch of
 information by default, and make the "only the peer id" an optional
 behavior…</div>
<div class="email-fragment">I think it would be nice to have the final command (e.g. ‘id’ here, or
‘publish’ in ‘ipfs name publish’) be either the action you want to
take or the data you want to get back.  So if ‘ipfs id …’ is about
“give me a bunch of information about &lt;peer&gt;”, maybe it should be
‘ipfs peer …’.  Then we could have:</div>
<span class="email-hidden-toggle"><a href="#">…</a></span><div class="email-hidden-reply" style="display:none">
<div class="email-signature-reply">$ ipfs peer --id
  QmbBHw1Xx9pUpAbrVZUKTPL5Rsph5Q9GQhRvcWVBPFgGtC

as a shortcut for:</div>
<div class="email-signature-reply">$ ipfs peer --format='&lt;id&gt;'
  QmbBHw1Xx9pUpAbrVZUKTPL5Rsph5Q9GQhRvcWVBPFgGtC

On the other hand, renames like this need an annoying multi-step
migration with a deprecation period, etc., so we'd want to do our best
to think through the indended UI to avoid further renames in the
coming months.  But we are talking about breaking the default output,
so maybe now is the time for that rename?</div>
</div>
EOF
    filter = EmailReplyFilter.new(body, {})
    doc = filter.call
    assert_equal expected.strip, doc
    assert_equal expected.strip, seen_live.strip
  end
end
