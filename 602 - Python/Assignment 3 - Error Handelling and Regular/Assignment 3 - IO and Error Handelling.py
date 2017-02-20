from Tkinter import Tk
from tkFileDialog import *
import re


def cars_doors(cars_door):
    pattern = "\'[v]?high.*[v]?high.*high.*\'"
    temp_list = []

    for stringss in cars_door:
        match_string = re.search(pattern, str(stringss))

        if match_string != None:
            temp = str(match_string.group()).split(",")
            temp_list.append(list(temp))

    final_sort = sortgivendata(temp_list, 'doors')

    print "\nFilter using Regular expression and Order by Door:"
    print "\n".join(["%s" %line for line in final_sort])
    print "\n".join("%s" %item for item in final_sort)
    return final_sort

def sortgivendata(unsorted_list, car_parameter):

    final_sort = []
    sortedlist_high = []
    file_parameters = list(carsdistinctvalues(unsorted_list,car_parameter))
    try:
        if car_parameter == 'doors':
            distinct_values = ['2', '3', '4', '5more']
            index = 2
        elif car_parameter == 'maintenance':
            distinct_values = ['low', 'med', 'high', 'vhigh']
            index = 1
        elif car_parameter == 'safety':
            distinct_values = ['low', 'med', 'high']
            if set(file_parameters) != set(distinct_values):
                raise Exception("Some bad data in input file")
            index = 5
    except Exception as error:
        print "Wrong input in the file. Please correct the file!. Ignoring bad input."

    for one_value in distinct_values:
        for i in range(len(unsorted_list)):
            if str(unsorted_list[i][index]).strip().replace("'", "") == str(one_value).strip().replace("'", ""):
                sortedlist_high.append(i)
    for j in sortedlist_high:
        final_sort.append(unsorted_list[j])
    return final_sort

##unsorded data
def carsdistinctvalues( cars_safety,car_parameter):

    unique_values = []
    if car_parameter == 'doors':
        index = 2
    elif car_parameter == 'maintenance':
        index = 1
    elif car_parameter == 'safety':
        index = 5

    for i in range(len(cars_safety)):
        unique_values.append(cars_safety[i][index])

    return set(unique_values)

def top15_main(cars_main, rows,order):

    final_sort = sortgivendata(cars_main,'maintenance')
    print "\nSort 15 maintenance cars in ascending order:"

    if order == 'des':
        print "\n".join(["%s" % line for line in final_sort[-rows:]])
        return final_sort[-rows:]
    else:
        print "\n".join(["%s" % line for line in final_sort[:rows]])
        return final_sort[:rows]

def top10_safety(cars_safety, rows, order):

    final_sort = sortgivendata(cars_safety,'safety')
    print "\nSort 10 safety cars in desending order:"
    if order == 'des':
        print "\n".join(["%s" %line for line in final_sort[-rows:]])
        return final_sort[-rows:]
    else:
        print "\n".join(["%s" %line for line in final_sort[:rows]])
        return final_sort[:rows]

def savefile(save_results):

    pattern = "\'(vhigh|high|med|low).*\\med.*\'4\'.*\'(4|more)\'.*\'"
    text_file = open("Output.txt", "w")
    print "\n", "Output saved to file:"
    for stringss in save_results:
        match_string = re.search(pattern,str(stringss))

        if match_string != None:

            temp = str(str(match_string.group()))
            print temp
            text_file.write(temp)
            text_file.write("\n")
    return True

if __name__ == "__main__":
    root = Tk()
    cars_result = []
    filename = askopenfilename(parent=root)
    print filename
    cars_dataset = open(filename, "r")
    for line in cars_dataset:
        line = line.split(",")
        del line[-1]
        cars_result.append(line)
    # cars_result[1][5]='vlow'
    # Print to the console the top 10 rows of the data sorted by 'safety' in descending order
    top10_safety(cars_result, 10, 'asc')
    # Print to the console the bottom 15 rows of the data sorted by 'maint' in ascending order
    top15_main(cars_result, 15, 'des')
    # Print to the console all rows that are high or vhigh in fields 'buying', 'maint', and 'safety', sorted by 'doors' in ascending order
    cars_doors(cars_result)
    # Save to a file all rows (in any order)
    savefile(cars_result)
