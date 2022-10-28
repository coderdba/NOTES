#https://machinelearningmastery.com/how-to-use-correlation-to-understand-the-relationship-between-variables/

#
# seaborn01.py -d mydatafile.txt
#
# Datafile format:
# a,b,c
# 1,2,3
# 4,5,6
# 7,8,9
#

import sys, getopt

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def main(argv):
   datafile = ''
   try:
      opts, args = getopt.getopt(argv,"hd:",["datafile="])
   except getopt.GetoptError:
      print(argv[0], "-d <datafile>")
      #print(argv[0])
      sys.exit(2)
   for opt, arg in opts:
      if opt == '-h':
         print(argv[0], "-d <datafile>")
         sys.exit()
      elif opt in ("-d", "--datafile"):
         datafile = arg
   print("Datafile is ", datafile)

   # sample data
   #data = pd.read_csv('https://www.dropbox.com/s/4jgheggd1dak5pw/data_visualization.csv?raw=1', index_col=0)

   data = pd.read_csv(datafile)
   corr = data.corr()
   print(corr)

   # Heatmap
   sns.heatmap(data.corr(), cmap="Reds", annot=True)
   plt.show()

   # Clustermap
   #sns.clustermap(data.corr(), cmap="Reds", annot=True,figsize=(24, 16))
   #plt.show()
   #plt.savefig('seaborn-map.png')

if __name__ == "__main__":
   main(sys.argv[1:])
