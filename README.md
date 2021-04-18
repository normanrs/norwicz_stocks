# norwicz_stocks
A simple app to gather financial data on reits and export them to an S3 bucket.

## Setup:
You will need the following environment variables available to run the app.

- TOKEN_FMP (Obtained from the Financial Modeling Prep API listed below)
- AWS_ACCESS_KEY_ID (Obtained from Amazon Web Services)
- AWS_BUCKET (Also Amazon)
- AWS_SECRET_ACCESS_KEY (Amazon once again)

You will also need:
- Ruby 2.6.6
- Bundler 2.2.7

## Instructions:
1. Clone this repo.
2. `bundle install` to install gem dependencies
2. `rake` to run all project tests OR `rake local` to skip attempting to write to AWS S3 bucket.

## Discussion
REIT (real estate investment trusts) ETFs (exchange-traded funds) are a special class of stock. They have numerous legal requirements that go above and beyond those for other stocks, restricting the extent to which they must be backed by assets and the percent of revenue they must return to investors in the form of dividends. This and the inherent value of real estate make them a particularly attractive investement in that they can be safer and yet still high-performing as compared to other stock types.
But in that they operate differently than other stocks they are also more difficult to evaluate in terms of price-to-performance. The normal metrics, such as price to earnings ration (P/E) or price to earnings growth (PEG) aren't good signals of a strong REIT. This app attempts to collect data that, when analyzed properly, CAN help determine if an REIT is worth investing in.
TTM (trailing twelve months) data is consistently used in an effort to evaluate the REIT over recent history, not just by its latest numbers or over the life of the trust.

## References
The API the app gets data from:
- [Financial Modeling Prep](https://financialmodelingprep.com/developer/docs/)

Also referenced:  
- [SEC Edgar](https://www.sec.gov/edgar/searchedgar/companysearch.html)
- [Gurufocus Financials](https://www.gurufocus.com/download_financials_batch.php)
- [Seeking Alpha](https://seekingalpha.com/symbol/SPG)
- [Motley Fool](https://www.fool.com/investing/general/2015/07/20/7-key-metrics-for-evaluating-equity-reits.aspx)
- [Simply Safe Dividends](https://www.simplysafedividends.com/intelligent-income/posts/21-the-most-important-metrics-for-reit-investing)