import matplotlib.pyplot as plt

base_phods = [1.82112085, 1.8211212, 1.82112504]
best_phods = [0.737999973, 0.738000381, 0.738004164]
sqr_phods = [1.23679242, 0.848138356, 0.738009578, 0.681567879]
rect_phods = [1.23679242, 0.931038754, 0.769117032, 0.719621661, 1.00595539, 
              0.848138356, 0.737767492, 0.684942876, 0.864458736, 0.773755019, 
              0.738009578, 0.700062898, 0.834159204, 0.747363723, 0.711379573,  0.681567879]

x_base = range(len(base_phods))
x_best = range(len(best_phods))
x_sqr = range(len(sqr_phods))
x_rect = range(len(rect_phods))

plt.plot(x_base, base_phods, marker='.', label='base_phods', color='blue')
plt.plot(x_best, best_phods, marker='.', label='best_phods', color='green')
plt.plot(x_sqr, sqr_phods, marker='.', label='sqr_phods', color='red')
plt.plot(x_rect, rect_phods, marker='.', label='rect_phods', color='purple')

plt.title("Best Design Space Exploration")
plt.ylabel("Time (ms)")
plt.legend()
plt.grid(True)

plt.xlim(0, len(rect_phods) - 1)
plt.ylim(min(min(base_phods), min(best_phods), min(sqr_phods), min(rect_phods)) - 0.05, 
         max(max(base_phods), max(best_phods), max(sqr_phods), max(rect_phods)) + 0.05)
         
plt.xticks([])
plt.show()