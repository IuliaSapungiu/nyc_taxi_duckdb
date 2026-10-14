import pathlib
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter

pathlib.Path("results").mkdir(exist_ok=True)

millions = FuncFormatter(lambda x, _: f"${x/1e6:.1f}M")

def demand_heatmap():
    df = pd.read_csv("results/06_demand_heatmap.csv")
    order = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    pivot = df.pivot(index="day_name", columns="pickup_hour", values="trips").reindex(order)

    fig, ax = plt.subplots(figsize=(12, 4))
    im = ax.imshow(pivot, aspect="auto", cmap="YlOrRd")
    ax.set_xticks(range(24))
    ax.set_xticklabels(range(24))
    ax.set_yticks(range(7))
    ax.set_yticklabels(order)
    ax.set_xlabel("Pickup hour")
    ax.set_title("NYC yellow taxi demand by weekday and hour (Jan-Mar 2024)")
    fig.colorbar(im, label="Trips")
    plt.tight_layout()
    plt.savefig("results/demand_heatmap.png", dpi=150)
    plt.close()


def daily_revenue():
    df = pd.read_csv("results/02_moving_average.csv", parse_dates=["date"])

    fig, ax = plt.subplots(figsize=(11, 4))
    ax.plot(df["date"], df["revenue"], alpha=0.4, label="Daily revenue")
    ax.plot(df["date"], df["moving_avg_7d"], linewidth=2.5, label="7-day moving average")
    ax.yaxis.set_major_formatter(millions) 
    ax.set_title("Daily taxi revenue (Jan-Mar 2024)")
    ax.set_ylabel("Revenue")
    ax.legend()
    plt.tight_layout()
    plt.savefig("results/daily_revenue.png", dpi=150)
    plt.close()


def top_zones():
    top = pd.read_csv("results/01_top_zones.csv").sort_values("revenue")

    fig, ax = plt.subplots(figsize=(9, 5))
    ax.barh(top["zone"], top["revenue"])
    ax.xaxis.set_major_formatter(millions)
    ax.set_title("Top 10 pickup zones by revenue (Jan-Mar 2024)")
    ax.set_xlabel("Revenue")
    plt.tight_layout()
    plt.savefig("results/top_zones.png", dpi=150)
    plt.close()


if __name__ == "__main__":
    demand_heatmap()
    daily_revenue()
    top_zones()
    print("Saved: demand_heatmap.png, daily_revenue.png, top_zones.png in results/")