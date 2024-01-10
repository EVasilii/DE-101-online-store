## Модель хранилища на PostgreSQL, слои и витрина данных.
Хранилище состоит из трех слоев:
<ul>
  <li> stg - слой "сырых" данных, представляющий собой таблицу с сырыми данными из источника.</li>
  <li> dw - слой, состоящий из 4-х таблиц измерений, таблицы календаря, и таблицы фактов. </li>
  <li> bl - слой, где располагаются витрины данных, необходимых для BI задач.</li>
</ul>
<p align="center">
Модель dw слоя
</p>
<p align="center">
      <img src="https://i.ibb.co/Jv1Zp6f/SQLDBmscren.png" width="950">
</p>
<hr>
<p align="center">
Слои и таблицы
</p>
<p align="center">
      <img src="https://i.ibb.co/YLrpVYd/sql-1.jpg" width="950">
</p>
<hr>
<p align="center">
Хранилище было продублировано в облаке с помощью сервиса AWS lightsail
</p>
<p align="center">
      <img src="https://i.ibb.co/f0hndQR/AWS.jpg" width="950">
</p>

