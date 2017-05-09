import re
pattern = '^M?M?M?$'
#print(re.search(pattern, 'MMMMM'))

pattern = '^M?M?M?(CM|CD|D?C?C?C?)$'
print(re.search(pattern,''))

pattern1 = '^M{0-3}$'

re.c


pattern = """
    ^                   # beginning of string
    M{0,4}              # thousands - 0 to 4 M's
    (CM|CD|D?C{0,3})    # hundreds - 900 (CM), 400 (CD), 0-300 (0 to 3 C's),
                        #            or 500-800 (D, followed by 0 to 3 C's)
    (XC|XL|L?X{0,3})    # tens - 90 (XC), 40 (XL), 0-30 (0 to 3 X's),
                        #        or 50-80 (L, followed by 0 to 3 X's)
    (IX|IV|V?I{0,3})    # ones - 9 (IX), 4 (IV), 0-3 (0 to 3 I's),
                        #        or 5-8 (V, followed by 0 to 3 I's)
    $                   # end of string
    """

re.search(pattern, 'M', re.VERBOSE)

##Main program
def match_reg(cars_safety):
    pattern = "\[\'(\\bvhigh|\\bhigh)\D{0,3}(\'\\bvhigh.*|\'\\bhigh.*)(\'\\bhigh.*)\]"
    pattern = "([v]high.*)"
    filter_list=[]
   # stringss = str(cars_safety[0])
    #print(cars_safety[0])
    #print(re.search(pattern,str(stringss)).groups())
    #print(cars_safety[1])
    print(re.search(pattern,str(cars_safety)).groups())
    #print(str(re.search(pattern,str(cars_safety[2])).groups()).replace("\""," "))


    # for stringss in cars_safety:
    #     #print str(stringss)
    #     match_string = re.search(pattern,str(stringss))
    #     if(match_string != None):
    #         temp_str = match_string.groups()
    #         filter_list.append(match_string.groups())
    # print(filter_list[1])
    return True

  elif(str(temp_list[i][3]).replace("'","") is '3' ):
            temp_list[i][6]=3
        elif(str(temp_list[i][3]).replace("'","")==4):
            temp_list[i][6]=4
        elif(str(temp_list[i][3]).replace("'","")=='5more'):
            temp_list[i][6]=5


if(str(temp_list[i][3]).strip().replace("'","")== str('3')):
            temp_list[i].append(3)
        if(str(temp_list[i][3]).strip().replace("'","")== str('4')):
            temp_list[i].append(4)
        else:
            temp_list[i].append(5)





#for i in range(len(temp_list)):
        #print(type(str(temp_list[i][3]).replace("'","")))
        #print(str(temp_list[i][3]))
    #if(float(temp_list[1][3].replace("'","")) == 2.0):


        #if(str(temp_list[i][3]).strip().replace("'","")== str('2')):
            #print "\n"
            #temp_list[i][6].append(2)
            #print temp_list[i]

    gridList = []
    for nlist in temp_list:
        row = []
        for item in nlist:
            row.append(0)
    gridList.append(row)
