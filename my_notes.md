# Unix and Git

## Unix

The piping operator "|" is different from Bash File Redirection "< or >" :

1. Piping operator - "|": Takes the output of one CLI command and "pipes" it directly into the next command (*without* any intermediate steps of saving the output as a separate file). **piping is used to pass an output to another program or utility**
        grep GOOG 2015_sp100.csv | sort | python <script_name.py>
    * explanation: Searches (grep) for GOOG in 2015_sp100.csv (file) and "pipes" that output directly into sort (sorts the data) and finally pipes that output into the python program <script_name.py>, whic is run by python

2. Bash File Redirection - ">" or "<": **redirection is used to pass output to a file or stream**
        grep GOOG 2015_sp100.csv > 2015_goog.csv
    * explanation: Searches (grep) for GOOG in 2015_sp100.csv and *saves* that output to the file 2015_sp100.csv

## Git

**Your master branch should ONLY be production code. ANY time you are working on code, create a separate branch, push/pull to/from Github as necessary, and only merge back onto master when you consider your code production ready**

    marsh$ git add <filename.ext> -p

The extension "-p" can used in conjunction with "git add <filename.txt>" in order to, "Interactively choose hunks of patch between the index and the work tree and add them to the index. This gives the user a chance to review the difference before adding modified contents to the index."

### Setting Multiple Remotes

When pair programming with one or more other developers, create a branch and then each developer should only work on their local copy of that branch, pushing/pulling to/from Github as necessary, and then only merging **and pushing** to master when the code is production ready.

To create a separate remote repo (other than the one you likely have on Github), do the following with the appropriate substitutions:

    marsh$ git remote add <name_for_remote> <SSH/URL for remote>

To push to that new remote:

    $ git fetch <partner-name>
    $ git checkout --track <partner-name>/pair
    $ git push <name_for_remote> <branch_name>

(Note that the difference between `git fetch` and `git pull` is that `git fetch` updates your remote tracking branches and `git pull` brings your current local branch up to date with the remote version, *while also updating your other remote-tracking branches*)
# Python

The "if \__name\__ == '\__main\__':" block of code usually appears at the end of a python script and allows the programmer to have code in their script that will only be run if the script is being run as the "main" program. If the script is being imported into another script and is being used as a module, then the code in this block will not be run.

What is happening *under the hood* is that, when the python interpreter reads a python script (anything.py file, either interactively in iPython or from the CL), it defines a few special variable before executing the script in a linear manner.

One of the variables that it sets up is "\__name\__" variable. At the very beginning of this process, Python sets this *\__name\__* variable equal to *\__main\__*, meaning that the script that you are running is the "main" script. Once that is done, it starts to execute the code in the main script. If you are importing any modules (which usually occurs at the top of the script), Python will go *into those external*, execute the code in them, and then return to the main script (If there are if \__name\__ == "\__main\__" blocks in the modules that are not the main script, they will not be run). When it gets to the end of the main script, it will execute the code in the if \__name\__ == "\__main\__" because it is the main script.

* This means that you could have an

        if __name__ == "__main__"

    in every script you write, and unless that script is the main script being run, the code within the if \__name\__ == "\__main\__" will not be run.

Example:

    # define functions and classes up here
    if __name__ == "__main__":
        # put code to test functions and classes here
        # only executed if this script is the 'main' script being run

## Unit Tests

### Test Driven Development

The "unittest" module is Python's framework for what is called Test Driven Development. Test Driven Development (TDD) is a paradigm from software engineering that allows you to test your code in a "blocked" manner; meaning you can specifically test each Class or function you write **without interference from any of your other code.** In other words, you don't need to test whether your entire script/program runs, you can test to see if the part that you are currently working on works how you are expecting it to work.

One of the goals behind TDD is that before you even write your code to accomplish the task that you are trying to accomplish, you write a test to test the code that you *will* write to accomplish that task. This has a couple of benefits:

1. It puts you in the "Top-Down" mindset of ensuring that your function, class, etc, will be set up to do **one** thing, and makes you think about some edge cases that could cause your code to output something unexpected.
2. In addition, there will be times when you are writing the test for your code and you realize that what you were going to have your code do does not serve your end goal, and you stop the process of trying to solve a meaningless problem before it starts in a sense.

Example:

    import unittest
    from <directory_name>.<script_name> import <class_that_has_code_to_be_tested>

    class TestStringMethods(unittest.TestCase):

    def setUp(self):
        """
        setup is used when significant setup is required
        this is not always needed.
        """
        self.a = answer_1
        self.b = answer_2

    def test<method_name>(self):
        """
        test multiplication functionality
        """
        test_result = <class_that_has_code_to_be_tested>.<method_to_be_tested(self.a, self.b)
        expected_result = self.a * self.b
        self.assertEqual(test_result, expected_result)

    if __name__ == '__main__':
        unittest.main()

Explanation: What the above code is doing, when it is run from the terminal using,

    marsh$ python -m unittest -v test_module.py

is importing "class_that_has_code_to_be_tested" from "directory_name.script_name", where all the code that you want to be tested is. Then, from within test_module.py, it is using the test <methd_name> function to test the actual code. These test methods usually have a variable that is the expected result, and a variable that is the result from the code to be tested (using the same arguments), and then an assert statement to see if they are true of not.

Running the following code from the terminal...

    marsh$ pycodestyle <script_name>.py

...allows you to see if the code within script_name.py is "Pythonic," (i.e follows python code style, with spaces and indentation where appropriate). The output of this command tell you where your "non-Pythonic" code is within your script, along with an error message that states what should be adjusted to make that line more Pythonic.

To **interactively** reload a program that you are working on while within a Python environment (iPython) you can import the *importlib* module and then run reload from that module, with the script name as the argument.

Example:

    [1]: import importlib
    [2]: importlib.reload(<module_name_OR_module_alias)

*Note that if you gave your module an alias when you initially imported it, you will use the alias as the argument to importlib.reload(), otherwise use the module name itself*

To avoid files accidentally being kept open when your code is run, use "with() as..." instead of "open()...close()"

Example:

    # do this
    with(filename.ext) as file1:
        for line in file1:
            print(line)

    # don't do this
    file1 = open(filename.ext)
    for line in file1:
        print(line)
    file1.close()

## Pandas, Numpy, Matplotlib

    # conventional aliases for packages
    [1]: import pandas as pd
    [2]: import numpy as np
    [3]: import matplotlib.pyplot as plt

### Pandas

Pandas is built on top of Numpy, one of the key differences being that a Panda Series (the columns in a pandas DataFrame) **can** have different data types within the same Series, while a Numpy array has to be all the same type. (However, this will lead to a decrease in speed, so if you can use a numpy array, use it.)

**Note that there will always be a trade-off between flexibility and speed when talking about the functionality of any programming module/package/library.**

**np.arrays have to all be one type, pd.series do NOT have to all be one type**

#### DataFrame

The DataFrame is the bread and butter of the Pandas module, analagous to data.frame's in R. There are a number of ways to create a DataFrame, three common way's being:

* Read in from a csv file:


    [1]: df = read_csv("<filepath>")


* Passing a dictionary to pd.DataFrame(), where the keys become the columns and the values becomes the values of their columns:


    [1]: df = pd.DataFrame({"col1": [1,2,3,4,5],
                            "col2": [6,7,8,9,10],
                            "col3": ["they","can","be",'any','type']})


* Passing a series of lists, where each lists represent an observation in the data set and then a separate list of column names as the columns argument:


    [1]: df = pd.DataFrame([[1,2,3,4,5],
                           [6,7,8,9,10],
                           [11,12,13,14,15]],
                           columns = ['col1','col2','col3','col4','col5'])


Creating date columns in Panda is easy using pd.date_range(start, stop, steoppd.date_range(start, stop, freq) allows you to add dates from start to stop, and the parameter freq allows you to step by days, weeks, months, years, even multiples of a unit. (Below is the month of January 2015, incremented by 2 hour steps.)


    [1]: date_column = pd.date_range('2015-01-01',
                                     '2015-01-31',
                                     freq = '2H')

##### Indexing Into DataFrames

Once again, there numerous ways to get specific observations or columns from a DataFrame, the two main ones being:

1. **df.loc[rows, columns]** - Locate based on labels (i.e column names, or indices of rows, if applicable)

2. **df.iloc[rows, columns]** - Locate based on positions in the index (i.e if the index of a data set are dates, you can still get the first 5 dates with pd.iloc[:6,:])

### Numpy

* **np.argmax()** returns the "absolute" index of the element with the maximum value within a numpy array. In order to get the actual value of the you need to use the ravel() method on the np array.


    [1]: index_corresponding_to_max_value = my_array.argmax()
    [2]: my_array.ravel()[index_corresonding_to_max_value]


The ravel() method "flattens" out your array so it will be a 1 x n dimensional array (where n is the number of observations in the dataset). Then indexing to that element is the same as a list

### Matplotlib

[matplotlib tutorials](https://matplotlib.org/users/tutorials.html)

No matter the situation, **Simple > Complex > Complicated**. Matplotlib is the workhorse of data visualization in python.

The general idea behind matplotlib is that when you instantiate a figure with  `plt.figure()`, it is equivalent to bringing a blank canvas up onto the painting stand for a painter.

Once you have instantiated your "blank canvas," you can define *where* on that canvas you want to paint with `ax = fig.add_subplot(rows,columns,selection)`, where you are conceptually dividing the canvas into rows and columns (integers in the function call) and the "selecting" the "section" of that subdivided canvas, where the subdivisions are numbered the same way you would read a page (1 starts at the upper left, go the number of columns to the right, drop a row, go to same number of columns to the right, and repeat untill you have reached the last (rows * columns) section)

    * Note that whenever you are adding a subplot to a canvas, any "painting" you have done on that canvas so far will remain there, so make sure you aren't painting over any existing visualizations by ensuring that your selection of subplot does not already have a plot in it.

    * If you would like to iteratively paint on the same canvas, you can instantiate your figure outside of a for loop and then add your subplots within the for loop (having the for loop iterate through the attributes you would like to plot)

### Basic Syntax

    [1]: import matplotlib.pyplot as plt
    [2]: fig = plt.figure(figsize=(8,6))
    [3]: ax = fig.add_subplot(1,1,1)
    [4]: ax.<some_drawing_functions>()
    [5]: ax.legend()
    [6]: ax.set_title(), ax.set_xlabel(), etc
    [7]: plt.show()

Note that matplotlib allows you to style all of your plots with a specific library, 'ggplot' being built in accordance with the ggplot package in R.

    [1]: plt.style.figure('ggplot')

# Databases

## SQL

Once a database is created in PostgreSQL, you can connect to that database from any directory on you machine (**assuming PostgreSQL is running, check, the elephant in the toolbar at the top of the screen**)

You can use bash file redirection to run a sql script from the CLI:

    marsh$ psql <database_name> < <script_name>.sql

### PostgreSQL Commands

* Create database:

        postgres=# CREATE DATABASE <database_name>

* Enter into the psql environment:

        marsh$ psql

* List databases:

        posgres-# \l

* Connect to database:

        postgres-# \c <database>

* Execute a query/script from within PostgreSQL:

        database=# \i <scriptname>

* Quit out of PostgreSQL:

        database=# \q

## NoSQL

**General analogies:**

**1. NoSQL databases = SQL databases**

**2. NoSQL collections = SQL tables**

**3. NoSQL documents = SQL records/observations/rows**

**4. NoSQL fields = SQL attributes/columns**


NoSQL stands for "Not only SQL (structured query language)" and allows for the storage and querying of unstructured data. One of the benefits of using NoSQL is when you might not know *exactly* the type of data that you want to store for future analysis, so using NoSQL allows you to cheaply store data, without worrying about how you are going to structure it immediately.

### MongoDB

**MongoDB is an instance of NoSQL, it is not the only system used to manage unstructured data.**

Start mongo from command line:

    marsh$ mongo

#### Commands

* Show databases

        > show dbs

* Connect to database

        > use <database>

* Show Connections (tables):

        > show connections

Once you have connected to a database, it becomes aliased as, "db" and all future queries/functions can be called with the format:

        > db.collections.<function>

        #example
        >db.log.findOne().pretty()

There are a numerous ways to query data using MongoDB, however the syntax is usually what will trip you up. **The general syntax is that the filter statement (analagous to WHERE in SQL), goes in position 1, the fields you want to select in position 2, and then any attributes/methods can be called at the end of the query using dot notation.**

        >db.collection.find({field: <condition>} [{field1: 1, field2: 2}]).pretty()

**Add .pretty() to all queries for pretty output where each d**

#### PyMongo

PyMongo is a module built to facilitate the interaction between Python and MongoDB and is the main way MongoDB will be accessed in a Python data pipeline.

    [1]: from pymongo import MongoClient
        # Establish connection to persistent storage
    [2]; client = MongoClient()
        # Access/Initiate database
    [3]: db = client['<database_name>']
        # Access/Initiate collection
    [4]: collection = db['<collection_name>']

When you are working with API's (i.e. not web-scraping) you are probably going to be working with the requests module when querying data, the syntax for which look like:

    [1]: import requests
    [2]: def single_query(endpoint, payload):
            response = requests.get(endpoint, params=payload)
            if response.status_code != 200:
                print('WARNING', response.status_code)
            else:
                return response.json()

**See "/Users/marsh/galvanize/dsi/ds-mongo" for pipeline of calling data from an API and pushing into MongoDB, all using PyMongo**

# Statistics

## Bayes Theorem

Bayes Theorem has names for each of the terms in the equation:

        P(A|B) = P(B|A) * P(A) / P(B)

where:

* P(A|B) = **Posterior**
* P(B) = **Normalizing Constant**
* P(B|A) = **Likelihood**
* P(A) = **Prior**

When you are performing Bayes Theorem, everytime you calculate it you update the prior to be equal to the posterior of the last iteration.

## Estimation

Broadly speaking, you can estimate using a parametric or non-parametric approach, each approach having different methods, each method having different benefits and consequences:

1. Parametric Estimation:
    * Method of Moments (MOM)
    * Maximum Likelihood Estimation (MLI)
    * Maximum A Posteriori

2. Non-Parametric Estimation:
    * Kernel Density Estimation

### Parametric Estimation

#### Method of Moments (MOM)

With MOM, **the moments are synonymous to parameters** of any given distribution.

The process is as follows:

1. Assume a distribution (Poisson, Exponentional, Binomial, Normal, etc).

2. Compute the relevant moments (read "parameters")
    * Note that you can **usually** calculate the sample mean and sample variance (and therefore the sample standard error) of any numeric attribute. **These values are then used to calculate the parameters that are specific to your assumed distribution**

3. Use the moments to calculate the parameters of your assumed distribution, then overlay a PDF or PMF on top of the histogram of your data and see if it makes sense.

Example: Given a vector that measures the number of mistakes a restaurant makes in an hour, you would be able to calculate the mean of that vector very easily. Then, *knowing that the Poisson distribution models rates particularly well**, you would assign the mean that you measure equal to lambda, and then overlay the Poisson PMF with parameter lambda on top of your histogram, seeing how well the theoretical distribution fits the data.

#### Maximum Likelihood Estimation (MLE)

The fundamental concepts underlying MLE can be broken down into three steps:

1. Assume a distribution (Poisson, Exponentional, Binomial, Normal, etc).

2. Define the likelihood function:
    * This will be the the probability of observing that data that you collected **given** a certain parameter or set of parameters

3. *Turn the conceptual knobs of each of of the parameters that defines the distribution that you assumed, until you get a parameter (or set of parameters i.e. mean, lambda, variance, etc)* **that maximizes your likelihood function**
    * This is saying that you are going to choose the parameter or set of parameters where the probability of observing the data *that you did in reality observe* **given that parameters or set of parameters** is greatest compared to any other parameter or set of parameters.

#### Maximum a Posteriori (MAP)

MAP can be considered the inverse of MLE: While MLE finds the parameter or set of parameters that maximize the probability of observing the observed data, *given those parameters*, MAP finds the parameters or set of parameters that are most probable, *given our observed data*.

### Non-Parametric Estimation

Non-parametric estimation is used when your data does not fit a known distribution well enough. So instead of assuming your data follows some known distribution, you take your data, "as is."

#### Kernel Density Estimation (KDE)

KDE, generally speaking, smooths the histogram of a distribution of data by summing "kernel functions" (which are usually Gaussian). KDE's have a bandwidth parameters that allows you to determine the variance of each individual kernel function.

    * As your bandwidth increases, your KDE will become smoother, likely leading to underfitting the data and not capturing some of the signal in your model. When plotted this will look overly 'smooth,' not capturing some of the subtleties of your data.
    * As your bandwidth decreases, your KDE becomes much less robust to noise, and overfitting is much more likely. What this looks like when plotted is a "spiky" graph.

## Sampling

The most basic form of sampling is a random sample, where you randomly sample from the population of interest, **making sure that the manner in which you sample does not lend itself to biasing your sample**

**Stratified Sampling** is when you want each of K groups equally represented in your sample, even though they might not be equally represented in your population. You select an equal number of people randomly from each group

**Cluster Random Sampling** is used when you want to analyze some refined population (i.e. women making > $100,000 that live in Boulder). Cluster sampling is an instance of basic random sampling where your population of interest is a very specific subset of some other total population
