# Grahams Rule Investing
#### About
I wrote *stock_market.R* in my free time while working my way through a
Coursera.org specialization, however I did end up using the script for a project
later in the specialization.

The purpose of the script was to be able to take in a series of ticker symbols,
determine whether they passed "Grahams Rule" (which can be found in the
Documentation tab (re-printed for convenience below) of the Shiny application),
and to what extent they passed Grahams Rule.

I did use a few "duct-tape" fixes on some of the errors I ran into, as opposed
to figuring out what root problem was. Reason for this was at the time, I was
allocating the majority of my time to the specialization.

##### start "Documentation Tab" re-print

**Version** 1.0.0

**Date**: 10/17/2017

**Net Current Asset Value per Share**
In the context of this application, the Net Current Asset Value per Share (NCAVPS) is defined as the per share value of current assets minus total liabilities, as stated in the footnote on page 391 of The Intelligent Investor.

**Graham's Rule**
In The Intelligent Investor, once again on page 391, Benjamin Graham states that a diversified portfolio of stocks whose NCAVPS is greater than the current price at which their stock is trading, should produce more than satisfactory results. Graham's Rule returns Pass if the company's NCAVPS is greater than the price at which their stock is currently trading and Fail if the current price is greater than the NCAPVS.

**Note that the vast majority of companies will not pass this test.**

**Margin of Safety**
The Margin of Safety is the percentage difference between the last price at which the stock was traded and the NCAVPS of the company.

If Graham's Rule is not passed, the Margin of Safety will return Invalid.

##### end "Documentation Tab" re-print

The Shiny Application can be found [here](https://marshallm94.shinyapps.io/simple_investments/)

*Note: Upon this writing (Friday, January 19, 2018), the shiny application is
deprecated, and for this reason, I have not included the UI and server code in
this directory. It seems as though the error is cause by a redirection from
http to https. stock_market.R still runs.*
