import pandas as pd
import dateutil.parser 
from datetime import datetime

def transform(f):
	
    def inside(r):
       	new_pd = f(r)
        for idx, j in new_pd.iterrows():
        	new_pd.loc[idx,'date_sk'] = dateutil.parser.parse(j['date']).strftime('%Y%m%d') 
        # dropping the old date column
        new_pd.drop('date', axis=1, inplace=True)
        print(new_pd) #printing data since its very small in this case.
        new_pd.to_csv('output_02.csv') # same data frame can be saved to parquet using pyarrow api. 

    return inside

@transform
def order_me(r):
    chunksize = 2
    pd_old = pd.DataFrame()
    for chunk in pd.read_csv(r, chunksize=chunksize, header=None, names = ["last_name", "first_name", "date", "email","id"]):
    	pd_old = pd_old.append(chunk[["id","first_name","last_name","date"]])

    return pd_old
    	

if __name__ == '__main__':
	filepath = 'data.csv'
	order_me(filepath)

  