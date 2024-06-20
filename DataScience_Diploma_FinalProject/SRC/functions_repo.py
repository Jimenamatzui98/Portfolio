import pandas as pd

#checar conteo nulos Columnas, Ascending False
def nancols(x):
    nan_cols = x.isna().sum()
    return nan_cols[nan_cols>0].sort_values(ascending=False)

def nancolsper(data):
    nan_cols = data.isna().mean() * 100
    return nan_cols[nan_cols > 0].sort_values(ascending=False).round(2)

#checar conteo nulos filas, Ascending False
def nanrows(x):
    nan_rows = x.isna().sum(axis=1)
    return nan_rows[nan_rows>0].sort_values(ascending=False)

#checar conteo de valores unicos por columnas, ascending false
def unique_cols(x):
    unique_cols = x.nunique()
    return unique_cols.sort_values(ascending=False)


#conteo de valores unicos por columno devuelto como DF para mejor visu
def col_unique_counts(df, col):
    counts = df[col].value_counts().reset_index()
    counts.columns = [col, 'Count']
    return counts


#checar dtypes unicos por columna
def get_unique_dtypes(df, col):
    unique_dtypes = df[col].apply(lambda x: type(x)).unique()
    return unique_dtypes


a= ([ 1, 1, 1, 2, 1, 1 ])

def findUnique(x):
    res=[]
    for num in x:
        if x.count(num) == 1:
            res.append(num)
            return res

#esta checalasgg

def time_of_day(hour): # funcion para agrupar y asi reducir la cantidad de horas del dia en periodos preestablecidos

    if '07' in hour or '08' in hour or '09' in hour or '10' in hour or '11' in hour or '12' in hour:
        return 'Morning'
    elif '13' in hour or '14' in hour or '15' in hour or '16' in hour or '17' in hour or '18' in hour or '19' in hour or '20' in hour or '21' in hour:
        return 'Afternoon'
    elif '22' in hour or '23' in hour or '00' in hour or '01' in hour or '02' in hour or '03' in hour or '04' in hour or '05' in hour or '06' in hour:
        return 'Night'
    else:
        return 'No information'
#data["Time_groups"] = data['Time'].apply(time_of_day)

def age_groups(age):
    if age == 0:
        return 'No information'
    elif age <= 12:
        return 'kid'
    elif age <= 19:
        return 'teen'
    elif age <= 60:
        return 'adult'
    elif age >= 60:
        return 'elderly'
    else:
        return 'No information'

#data['age'] = data['age'].apply(age_of_victims)
