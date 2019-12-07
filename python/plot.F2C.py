# sphinx_gallery_thumbnail_number = 3
import matplotlib.pyplot as plt
import numpy as np

x = np.linspace(20, 100, 8)

plt.plot(x, (x-32)*5/9, label='C')

plt.xlabel('F')
plt.ylabel('C')

plt.title("F vs c plot")

plt.legend()

plt.show()