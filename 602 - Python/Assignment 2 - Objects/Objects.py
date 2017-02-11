# 1. fill in this class
#   it will need to provide for what happens below in the
#	main, so you will at least need a constructor that takes the values as (Brand, Price, Safety Rating),
# 	a function called showEvaluation, and an attribute carCount
class CarEvaluation:
    'A simple class that represents a car evaluation'

    # all your logic here

    def __init__(self, brand, price, safty_rating):
        self.brand = brand
        self.price = price
        self.safty_rating = safty_rating

    def showEvaluation(self):
        print "The %s has a %s price and it's safety is rated a %s" % (self.brand, self.price, self.safty_rating)


# 2. fill in this function
#   it takes a list of CarEvaluation objects for input and either "asc" or "des"
#   if it gets "asc" return a list of car names order by ascending price
# 	otherwise by descending price
def sortbyprice(carslist,order):  # you fill in the rest
    category = {"low":1,"medium":2,"high":3}
    category.keys()
    orderlist =[]
    for i in range(0,len(carslist)):
        if order =="asc":
#            if carslist[i].price == "High":
             orderlist.append(carslist[i].brand)
    print orderlist
    return True

# 3. fill in this function
#   it takes a list for input of CarEvaluation objects and a value to search for
#	it returns true if the value is in the safety  attribute of an entry on the list,
#   otherwise false
def searchforsafety():
    # you fill in the rest
    pass  # return a value


# This is the main of the program.  Expected outputs are in comments after the function calls.
if __name__ == "__main__":
    eval1 = CarEvaluation("Ford", "High", 2)
    eval2 = CarEvaluation("GMC", "Med", 4)
    eval3 = CarEvaluation("Toyota", "Low", 3)


    #    print "Car Count = %d" % CarEvaluation.carCount  # Car Count = 3

#   eval1.showEvaluation()  # The Ford has a High price and it's safety is rated a 2
#   eval2.showEvaluation()  # The GMC has a Med price and it's safety is rated a 4
#   eval3.showEvaluation()  # The Toyota has a Low price and it's safety is rated a 3

    L = [eval1, eval2, eval3]
    print sortbyprice(L, "asc");  # [Toyota, GMC, Ford]
#    print sortbyprice(L, "des");  # [Ford, GMC, Toyota]
# print searchforsafety(L, 2); #true
#    print searchforsafety(L, 1); #falsea
