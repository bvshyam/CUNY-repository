# 1. fill in this function
#   it takes a list for input and return a sorted version
#   do this with a loop, don't use the built in list functions

import numpy as np
import timeit, functools
from prettytable import PrettyTable
import csv
import copy

def sortwithloops(input):
# Bubble sort

    for j in xrange(0, len(input) - 1):
        for i in xrange(0, len(input) - 1):
            if input[i]> input[i+1]:
                test = input[i]
                input[i] = input[i+1]
                input[i+1] = test
    return input


# 2. fill in this function  # it takes a list for input and return a sorted version
#   do this with the built in list functions, don't us a loop
def sortwithoutloops(input):
    return sorted(input)


#Numpy sort with normal list
def numpy_normal_list(sort_list):
    return np.sort(sort_list)


#Numpy sort with numpy array
def numpy_num_array(sort_list):
    return np.array(sort_list).sort()


def gen_list(i):
    return list(np.random.choice(xrange(100), i))

def call_sort(L,i):
    sort_perf = PrettyTable(['Method', 'Time', 'Iterations perfomed'])

    s1 = timeit.Timer(functools.partial(numpy_normal_list, copy.copy(L)))
    sort_perf.add_row(["Normal List with Numpy sorting", s1.timeit(number=i), i])

    s2 = timeit.Timer(functools.partial(numpy_num_array, copy.copy(L)))
    sort_perf.add_row(["Numpy array with Numpy sorting", s2.timeit(number=i), i])

    s3 = timeit.Timer(functools.partial(sortwithloops, copy.copy(L)))
    sort_perf.add_row(["Manual sorting with loops", s3.timeit(number=i), i])

    s4 = timeit.Timer(functools.partial(sortwithoutloops, copy.copy(L)))
    sort_perf.add_row(["Sorting with build in sort function", s4.timeit(number=i), i])

    print sort_perf

if __name__ == "__main__":

    # File Import
    brain_body = open("data\/brainandbody.csv", "r")
    files = csv.reader(brain_body)
    lists =[]
    row_num = 0
    for br_bo in files:
        if row_num == 0:
            row_num += 1
        else:
            lists.append(float(br_bo[2])*50000)

    # Number of iterations
    i = 1000
    L = gen_list(i)

    print "Sort Random numbers"
    call_sort(L, i)

    print "Sort brain and body data"
    call_sort(lists, i)
