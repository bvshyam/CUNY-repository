# Download the new data set on the Lesson 5 page called brainandbody.csv.  This file is a small set of average brain weights and average body weights for a number of animals.  We want to see if a relationship exists between the two. (This data set acquired above).
# Perform a linear regression using the least squares method on the relationship of brain weight [br] to body weight [bo].  Do this using just the built in Python functions (this is really easy using scipy, but we're not there yet).  We are looking for a model in the form bo = X * br + Y.  Find values for X and Y and print out the entire model to the console.

import csv
import math

# Calculating Mean


def mean(x):
    return sum(x)/len(x)

# Calculating Standard deviation


def manual_sd(sd_values):
    mean_val = mean(sd_values)
    sd = math.sqrt(sum((i-mean_val)*(i-mean_val) for i in sd_values)/(len(sd_values)-1))
    return sd

# Calculating Correlation


def correlation(cor_br, cor_bo):
    mean_cor_br = mean(cor_br)
    mean_cor_bo = mean(cor_bo)

    sd_a = manual_sd(cor_br)
    sd_b = manual_sd(cor_bo)
    R = []
    for i in range(len(cor_br)):
        R.append(((cor_br[i]-mean_cor_br)*(cor_bo[i]-mean_cor_bo))/(sd_a*sd_b))
    R_correlation = sum(R)/(len(cor_br)-1)
    return R_correlation


if __name__ == "__main__":
    brain_body = open("data\/brainandbody.csv", "r")
    reader = csv.reader(brain_body)
    br = []
    bo = []
    row_num = 0
    # test =[]
    # a = (test.append(float(record[1])) for record in reader)
    # print a

    try:
        for brbo in reader:
            if row_num == 0:
                header = brbo
                row_num += 1
            else:
                br.append(float(brbo[2]))
                bo.append(float(brbo[1]))
        sd_br = manual_sd(br)
        sd_bo = manual_sd(bo)
        R = correlation(br, bo)
        x = (sd_bo/sd_br)*R
        y = mean(bo) - x*mean(br)

        print "BO = %s *BR + %s " % (x, y)

    except Exception as error:
        print "Error in input file or please correct it!"


