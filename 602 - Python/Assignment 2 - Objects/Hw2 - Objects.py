# 1. fill in this class
#   it will need to provide for what happens below in the
#	main, so you will at least need a constructor that takes the values as (Brand, Price, Safety Rating),
# 	a function called showEvaluation, and an attribute carCount
class CarEvaluation:
    'A simple class that represents a car evaluation'

    # all your logic here
    carCount =0
    def __init__(self, brand, price, safty_rating):
        self.brand = brand
        self.price = price
        self.safty_rating = safty_rating
        CarEvaluation.carCount =CarEvaluation.carCount+1
    def showEvaluation(self):
        print "The %s has a %s price and it's safety is rated a %s" % (self.brand, self.price, self.safty_rating)


# 2. fill in this function
#   it takes a list of CarEvaluation objects for input and either "asc" or "des"
#   if it gets "asc" return a list of car names order by ascending price
# 	otherwise by descending price
def sortbyprice(carslist,order):  # you fill in the rest
    cars_price= {}
    values=[]
    for i in range(0,len(carslist)):
        cars_price[updateprice(carslist[i].price)] = carslist[i].brand

    if(order=="des"):
        keylist = sorted(cars_price.keys(),reverse=True)
        print("Decending Order")
        for key in keylist:
            values.append(cars_price[key])
    elif(order=="asc"):
        keylist = sorted(cars_price.keys())
        print("Ascending Order")
        for key in keylist:
            values.append(cars_price[key])
    return values

#def sortbyprice1(carslist,order):  # you fill in the rest
#    print "\n".join(["%s" % (cars.price) for cars in carslist])

def updateprice(price):
    if(price=="Low"):
        return 1
    elif(price=="Med"):
        return 2
    elif(price=="High"):
        return 3
    else: return 2

# 3. fill in this function
#   it takes a list for input of CarEvaluation objects and a value to search for
#	it returns true if the value is in the safety  attribute of an entry on the list,
#   otherwise false
def searchforsafety(carslist,safty_index):
    for cars in carslist:
        if(cars.safty_rating==safty_index):
            return True
        else:
            return False



# This is the main of the program.  Expected outputs are in comments after the function calls.
if __name__ == "__main__":
    eval1 = CarEvaluation("Ford", "High", 2)
    eval2 = CarEvaluation("GMC", "Med", 4)
    eval3 = CarEvaluation("Toyota", "Low", 3)


    print "Car Count = %d" % CarEvaluation.carCount  # Car Count = 3

    eval1.showEvaluation()  # The Ford has a High price and it's safety is rated a 2
    eval2.showEvaluation()  # The GMC has a Med price and it's safety is rated a 4
    eval3.showEvaluation()  # The Toyota has a Low price and it's safety is rated a 3

    L = [eval1, eval2, eval3]
    print sortbyprice(L, "asc");  # [Toyota, GMC, Ford]
    print sortbyprice(L, "des");  # [Ford, GMC, Toyota]
    print searchforsafety(L, 2); #true
    print searchforsafety(L, 1); #falsea
