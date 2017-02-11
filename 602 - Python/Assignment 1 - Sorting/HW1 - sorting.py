# 1. fill in this function
#   it takes a list for input and return a sorted version
#   do this with a loop, don't use the built in list functions
def sortwithloops(input):
#Bubble sort

    for j in xrange(0, len(input) - 1):
        for i in xrange(0, len(input) - 1):
            if(input[i]> input[i+1]):
                test = input[i]
                input[i]= input[i+1]
                input[i+1]=test
    return input


# 2. fill in this function  # it takes a list for input and return a sorted version
#   do this with the built in list functions, don't us a loop
def sortwithoutloops(input):
    output = sorted(input)
    return output


# 3. fill in this function
#   it takes a list for input and a value to search for
#	it returns true if the value is in the list, otherwise false
#   do this with a loop, don't use the built in list functions
def searchwithloops(input, value):
    for i in (0, len(input)):
        if (input[i] == value):
            return True
        else:
            return False

# 4. fill in this function
#   it takes a list for input and a value to search for
#	it returns true if the value is in the list, otherwise false
#   do this with the built in list functions, don't use a loop
def searchwithoutloops(input, value):
    if (value in input):
        return True
    else:
        return False

# return #return a value

def listcount(input):

    return True

if __name__ == "__main__":
    L = [5, 3, 6, 3, 13, 5, 6]

    print sortwithloops(L)  # [3, 3, 5, 5, 6, 6, 13]
    print listcount(L)
    print sortwithoutloops(L)  # [3, 3, 5, 5, 6, 6, 13]
    print searchwithloops(L, 5)  # true
    print searchwithloops(L, 11)  # false
    print searchwithoutloops(L, 5)  # true
    print searchwithoutloops(L, 11)  # false
