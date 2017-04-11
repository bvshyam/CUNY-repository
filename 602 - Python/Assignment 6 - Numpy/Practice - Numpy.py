import numpy as np
# Create an array with 10^7 elements.
#arr = np.arange(1e7)
#print arr
# Converting ndarray to list
#larr = arr.tolist()
# Lists cannot by default broadcast, # so a function is coded to emulate # what an ndarray can do.
# Creating a 3D numpy array
def numpy_test():
    arr = np.zeros((3,3,3))
    # Trying to convert array to a matrix, which will not work
    #print 1,4
    print np.array(range(1,5))

    #print 1:100
    print np.arange(100)

    #Print values in steps
    print np.linspace(0,1,100)

    #Print values in log steps
    print np.logspace(0,1,100,base=10)

    #Print values in matrix format
    print np.zeros((5,5))

    # Creating a 5x5x5 cube of 1's
    # The astype() method sets the array with integer elements.
    print np.zeros((5,5,5)).astype(int) + 1

    # Or even simpler with 16-bit floating-point precision...
    print np.ones((5, 5, 5)).astype(np.float16)

    print np.zeros(2, dtype=np.float32)

    arr1d = np.arange(1000)

    # Now reshaping the array to a 10x10x10 3D array
    print arr1d.reshape((10,10,10))

    # Inversely, we can flatten arrays
    arr4d = np.zeros((10, 10, 10, 10))

    #Flatten the multi dimensional object
    print arr4d.ravel()

    print np.zeros((2,))

    # Creating an array of zeros and defining column types
    recarr = np.zeros((2,), dtype=('i4,f4,a10'))
    toadd = [(1,2.,'Hello'),(2,3.,"World")]
    recarr[:] = toadd

    print np.arange(2)

    # Now creating the columns we want to put # in the recarray
    col1 = np.arange(2) + 1
    col2 = np.arange(2, dtype=np.float32)
    col3 = ['Hello', 'World']
    # Here we create a list of tuples that is # identical to the previous toadd list.
    toadd = zip(col1, col2, col3)
    recarr[:] = toadd
    print recarr

    recarr.dtype.names = ('Integers' , 'Floats', 'Strings')
    print recarr[[0]]


    alist=[[1,2],[3,4]]
    arr=np.array(alist)
    print arr[1,:]

    arr = np.arange(5,20,2)

    print arr
    index = np.where(arr > 16)
    print index

    new_arr = np.delete(arr, index)
    index = arr > 12
    print(index)
    return 0

def list_times(alist, scalar):

    for i, val in enumerate(alist):
        alist[i] = val * scalar
    return alist

def numpy_image():
    # Creating an image
    img1 = np.zeros((20, 20)) + 3
   # print img1
    img1[4:-4, 4:-4] = 6
    img1[7:-7, 7:-7] - 9
    print img1

    # See Plot A # Let's filter out all values larger than 2 and less than 6.
    index1 = img1 > 2
    index2 = img1 < 6
    compound_index = index1 & index2 # The compound statement can alternatively be written as
    compound_index = (img1 > 3) & (img1 < 7)
    img2 = np.copy(img1)
    img2[compound_index] = 0 # See Plot B. # Making the boolean arrays even more complex
    index3 = img1 == 9
    index4 = (index1 & index2) | index3
    img3 = np.copy(img1)
    img3[index4] = 0 # See Plot C.
    return 0

def numpy_random():
    import numpy.random as rand
    # Creating a 100-element array with random values from a standard normal distribution or, in other # words, a Gaussian distribution. # The sigma is 1 and the mean is 0.
    a = rand.randn(100) # Here we generate an index for filtering # out undesired elements.
    print a
    index = a > 0.2
    print index
    b = a[index] # We execute some operation on the desired elements.
    b = b[1] ** 2 - 2 # Then we put the modified elements back into the # original array.
    print b
    a[index] = b
    print a

    return 0

def numpy_binary():
    data = np.empty((1000, 1000))
    np.savez('test.npy', data)
    return 0

def numpy_matrix():
    A = np.matrix([[3,6,-5],[1,-3,2],[5,-1,4]])
    B = np.matrix([[12],[-2],[10]])

    X= A** (-1) * B
    print X
    a = np.array([2,3,4,5,6,8])
    b = np.array([8,5,4])
    c = np.array([5,4,6,8,3])
    #a.reshape((2,2,1))

    ax= np.ix_(a)
   # print ax.shape
    print ax
    print np.eye(2)
    A = np.matrix('1.0 2.0 4.0; 3.0 4.0 7.0;4 6 1;3 7 2')
    print A

    A = np.arange(12)
    A.shape = (3,4)
    print A
    print A[1:,]
    M = np.mat(A.copy())
    print M
    print M[:,1]

    a = np.arange(30)
    a.shape = 2,-1,3
    print a.shape

if __name__=="__main__":
    #numpy_test()
    #numpy_image()
    #numpy_random()
    #numpy_binary()
    numpy_matrix()

