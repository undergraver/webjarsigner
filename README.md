# webjarsigner
This project offers the possibility to sign jar files over a web interface

# What is required
1. Apache with PHP enabled as the main interface is written in PHP
2. Bash capability to execute scripts
3. Java development kit or access to jarsigner executable
4. Configuration file containing the parameters for signing

# How to use

1. Clone the repository in a path where php is enabled
2. Set access to the apache user (apache/apache2/wwrun etc) or its group to r-x so that it can access the php file

NOTE: While the PHP code might work in other envrionments the project was tested under Linux
