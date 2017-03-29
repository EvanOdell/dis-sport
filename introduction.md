-   [Creating the dis-sport map](#creating-the-dis-sport-map)
    -   [The tools you need](#the-tools-you-need)
    -   [Accessing the data](#accessing-the-data)
        -   [1. From the Charity Commission](#from-the-charity-commission)
        -   [2. From evanodell.com](#from-evanodell.com)
        -   [Postcodes](#postcodes)
    -   [Setting up the database](#setting-up-the-database)
    -   [Creating the dataset](#creating-the-dataset)

<!-- README.md is generated from README.Rmd. Please edit that file -->
Creating the dis-sport map
==========================

The tools you need
------------------

You will have to install a few programs to create these visuals. All of these programs are

1.  R, a programming language, download [here](https://cran.r-project.org/).

2.  RStudio, a program providing an easier-to-use interface for R, [download here](https://www.rstudio.com/products/RStudio/). You'll need the desktop version, not the server version.

3.  A local SQL database. I use [PostgreSQL](https://www.postgresql.org/download/). It is possible to use Microsoft Access, which is included with Microsoft Office (on Windows), but Access lacks basic features, such as reading multiple CSV files into a daatabase, that will make using it incredibly frustrating. There is a guide to installing Postgres in the official [wiki](https://wiki.postgresql.org/wiki/Detailed_installation_guides), and a good introductory tutorial [here](https://www.tutorialspoint.com/postgresql/index.htm).

4.  A database manager. I recommend [DBeaver](dbeaver.jkiss.org/download/), but a range of options are available.

Accessing the data
------------------

There are two ways to access the data used to make this map:

### 1. From the Charity Commission

The first is from the [Charity Commission](http://data.charitycommission.gov.uk/) data download. The NCVO has a guide to accessing this data [here](https://data.ncvo.org.uk/a/almanac16/how-to-create-a-database-for-charity-commission-data/), with more extensive documentation and code [here](https://github.com/ncvo/charity-commission-extract/).

### 2. From evanodell.com

I've put cleaned and ready-to-go copies of all the CSV files you need on [my website](http://evanodell.com/datasets/charity-data/). They will typically be available within a week of the latest Charity Commission release. I reccomend using this data, as it has been formatted for Postgres.

### Postcodes

You will also need postcode latitude and longitude data. Download the England postcodes file from [Doogal](https://www.doogal.co.uk/PostcodeDownloads.php). It is labelled as 'single file that is too large for Excel - England', which is okay because you won't need to open it in Excel. Once downloaded, rename the file to `england_postcodes.csv`.

Setting up the database
-----------------------

Set up a database named 'charity' in postgres, and give your user full administrative capabilities.

Creating the dataset
--------------------

You don't need all the charity commission data files to create the dataset for the map. You only need the following:

1.  `extract_charity`

2.  `extract_main_charity`

3.  `extract_object` if using data directly from the charity commission (requires an extra step), or `extract_proper_object` is using the data from [evanodell.com](http://evanodell.com/datasets/charity-data/)

4.  `extract_class`

5.  `extract_class`

6.  `england_postcodes`

Load these files into your database using DBeaver. DBeaver will automatically create new database tables. Set the datatype of all columns in `extract_class` and `extract_class` to text.

You will also need to install the [tablefunc](https://www.postgresql.org/docs/9.1/static/tablefunc.html) extension for Postgres, see [here](https://www.postgresql.org/docs/9.1/static/sql-createextension.html) for a guide to installing extensions.

Load the [prospects.sql](prospects.sql) file into DBeaver. Select and run each the 'sets' of commands one by one. Only run set 2 if using the data directly from the charity comission.

Export the newly created table called `gya_prospects` to a csv file. Move it to the file directory you are working it and rename it `gya_prospects.csv`.
