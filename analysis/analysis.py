import os
import pandas as pd
import psycopg2 as pg
import connection.execute as exec
from faker import Faker
import random
import seaborn as sns
import matplotlib.pyplot as plt


def get_quantiles(df, column):
    return df[column].quantile(q=.25), df[column].quantile(q=.75)

if __name__ == '__main__':
    conn = exec.psycopg2_conn()

    for i in range(91,141):
        sql_ins = f"INSERT INTO wt.goods_in_warehouse VALUES ({random.randint(1, 10)}, {i}, {random.randint(1,15)})"
        exec.exec_sql(sql_ins, False)

    conn.commit()

    df = exec.exec_sql("SELECT * FROM items_in_warehouse", True)

    renaming = {
        "warehouse_id": "Номер склада"}


    for hue in renaming.keys():
        g = sns.PairGrid(df[['cost', 'num_of_items_in_warehouse', 'summary_taken_space', hue]],
                         hue=hue, diag_sharey=False, palette="Set2", height=3)
        g.fig.subplots_adjust(top=0.95)
        g.fig.suptitle(renaming[hue])

        g.map_lower(sns.kdeplot, alpha=0.6)
        g.map_upper(sns.scatterplot, alpha=0.5)
        g.map_diag(sns.kdeplot, lw=3, alpha=0.9,
                   common_norm=False)
        g.add_legend()
        plt.show()


    df = exec.exec_sql("SELECT * FROM orders_info", True)
    sns.catplot(
        x="num_of_items",
        y="total_cost_of_order",
        kind='box',
        data=df)
    Q1, Q3 = get_quantiles(df, "total_cost_of_order")
    IQR = Q3 - Q1
    plt.ylim(0, Q3 + 2.3 * IQR)
    plt.grid(which='major', color='k', linestyle=":")
    plt.title("плотбоксы распределений стоимости в зависимости от количества товаров")
    plt.xlabel("количество товаров в заказе")
    plt.ylabel("суммарная стоимость заказа")
    plt.locator_params(axis='y', nbins=10)
    plt.show()



    df = exec.exec_sql("SELECT * FROM orders_info", True)
    sns.catplot(
        y="total_cost_of_order",
        kind='box',
        data=df)
    Q1, Q3 = get_quantiles(df, "total_cost_of_order")
    IQR = Q3 - Q1
    plt.ylim(0, Q3 + 2.3 * IQR)
    plt.grid(which='major', color='k', linestyle=":")
    plt.title("плотбоксы распределений стоимости в зависимости от количества товаров")
    plt.ylabel("суммарная стоимость заказа")
    plt.locator_params(axis='y', nbins=10)
    plt.show()