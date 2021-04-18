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

## References
The API the app gets data from:
- [Financial Modeling Prep](https://financialmodelingprep.com/developer/docs/)

Also referenced:  
- [SEC Edgar](https://www.sec.gov/edgar/searchedgar/companysearch.html)
- [Gurufocus Financials](https://www.gurufocus.com/download_financials_batch.php)
- [Seeking Alpha](https://seekingalpha.com/symbol/SPG)
- [Motley Fool](https://www.fool.com/investing/general/2015/07/20/7-key-metrics-for-evaluating-equity-reits.aspx)
- [Simply Safe Dividends](https://www.simplysafedividends.com/intelligent-income/posts/21-the-most-important-metrics-for-reit-investing)