import requests
import pandas as pd
import numpy as np
from scipy.stats import pearsonr, kendalltau, rankdata, norm

def fetch_metrics(prometheus_url, query, start_time, end_time):
    response = requests.get(f"{prometheus_url}/api/v1/query_range", params={
        'query': query,
        'start': start_time,
        'end': end_time,
        'step': '1m'
    })
    data = response.json()['data']['result']
    return data

def extract_values(data):
    timestamps = [point[0] for point in data[0]['values']]
    values = {metric['metric']['__name__']: [float(point[1]) for point in metric['values']] for metric in data}
    df = pd.DataFrame(values, index=pd.to_datetime(timestamps, unit='s'))
    return df

def compute_correlations(df, main_metric):
    correlations = {}
    for metric in df.columns:
        if metric != main_metric:
            pearson_corr, _ = pearsonr(df[main_metric], df[metric])
            kendall_corr, _ = kendalltau(df[main_metric], df[metric])
            ksai_value, _ = xicor(df[main_metric], df[metric])  # Compute KSAI using xicor function
            correlations[metric] = {'Pearson': pearson_corr, 'Kendall': kendall_corr, 'KSAI': ksai_value}
    return correlations

def xicor(x, y, ties="auto"):
    x = np.asarray(x).flatten()
    y = np.asarray(y).flatten()
    n = len(y)

    if len(x) != n:
        raise IndexError(f"x, y length mismatch: {len(x)}, {len(y)}")

    if ties == "auto":
        ties = len(np.unique(y)) < n
    elif not isinstance(ties, bool):
        raise ValueError(f"expected ties either \"auto\" or boolean, got {ties} ({type(ties)}) instead")
    
    y = y[np.argsort(x)]
    r = rankdata(y, method="ordinal")
    nominator = np.sum(np.abs(np.diff(r)))

    if ties:
        l = rankdata(y, method="max")
        denominator = 2 * np.sum(l * (n - l))
        nominator *= n
    else:
        denominator = np.power(n, 2) - 1
        nominator *= 3

    statistic = 1 - nominator / denominator  # upper bound is (n - 2) / (n + 1)
    p_value = norm.sf(statistic, scale=2 / 5 / np.sqrt(n))

    return statistic, p_value

def main():
    prometheus_url = input("Enter Prometheus URL: ")
    queries = input("Enter metric queries (comma-separated): ").split(',')
    start_time = input("Enter start time (RFC3339 format): ")
    end_time = input("Enter end time (RFC3339 format): ")
    main_metric = input("Enter main metric: ")

    all_data = []
    for query in queries:
        data = fetch_metrics(prometheus_url, query, start_time, end_time)
        all_data.extend(data)

    df = extract_values(all_data)
    correlations = compute_correlations(df, main_metric)

    for metric, corr in correlations.items():
        print(f"Correlations for {metric} against {main_metric}:")
        print(f"  Pearson: {corr['Pearson']}")
        print(f"  Kendall: {corr['Kendall']}")
        print(f"  KSAI: {corr['KSAI']}")

if __name__ == "__main__":
    main()
