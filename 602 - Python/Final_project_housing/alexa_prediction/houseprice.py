from flask_ask import Ask, statement, question, session
import json
import requests
import time
import unidecode
import numpy as np
import pandas as pd
from flask import Flask, json, render_template
import sklearn as sk
from sklearn import ensemble

app = Flask(__name__)
ask = Ask(app, '/')


#Create a model
df = pd.read_csv("..\\data\\train.csv")
df_num_na = df.select_dtypes(['number'])
df_num = df_num_na.apply(lambda x:x.fillna(x.median()))
df_num_clean = df_num[['OverallQual','YearBuilt','LotArea','GrLivArea','SalePrice']]
df_num_clean_log = df_num_clean.apply(lambda x: np.log1p(x))

msk = np.random.rand(len(df_num_clean_log)) < 1
train_X = df_num_clean_log.loc[:,['OverallQual','YearBuilt','LotArea','GrLivArea']][msk]
train_Y = pd.DataFrame(df_num_clean_log.loc[:,'SalePrice'][msk])


#test_X = df_num_clean_log.loc[:,['OverallQual','YearBuilt','LotArea','GrLivArea']][~msk]
#test_Y = pd.DataFrame(df_num_clean_log.loc[:,'SalePrice'][~msk])

test_X = pd.DataFrame(columns=['OverallQual','YearBuilt','LotArea','GrLivArea'])


rf_param = ensemble.RandomForestRegressor()
cols = list(train_X.columns.values)
model_rf = rf_param.fit(train_X[cols],train_Y.SalePrice)

#r2 = sk.metrics.r2_score(test_Y.SalePrice, model_rf.predict(test_X[cols]))
#mse = np.mean((test_Y.SalePrice - model_rf.predict(test_X[cols]))**2)
#rmse = sqrt(np.mean((test_Y.SalePrice - model_rf.predict(test_X[cols]))**2))


@ask.launch
def start_skill():
	welcome_text = render_template('welcome')
	return question(welcome_text)
	#return question(welcome_text).reprompt(help_text)


@ask.intent("QualityIntent", convert={'quality': int,'year': int,'lot': int, 'living': int})
def quality(quality,year,lot,living):
	if ((quality < 11) and (year > 1800) and (lot > 1300) and (living > 334)):
		print(quality)
		print(year)
		print(lot)
		print(living)
		test_X.set_value(1,'OverallQual',quality)
		test_X.set_value(1,'YearBuilt',year)
		test_X.set_value(1,'LotArea',lot)
		test_X.set_value(1,'GrLivArea',living)
		value = np.exp(model_rf.predict(test_X[cols]))
		print(value)
		results_text = render_template('result',sel_result = value)
		year_text = render_template('year')
		return statement(results_text)

	else:
		quality_wrong_text = render_template('quality_wrong')
		return statement(quality_wrong_text)


if __name__=="__main__":
	app.run(debug=True)