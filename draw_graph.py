import sys
import matplotlib.pyplot as plt
import pandas as pd
import networkx as nx

input_data = pd.read_csv('test.csv', index_col=0)
G = nx.Graph(input_data.values)
nx.draw(G)
plt.show()
