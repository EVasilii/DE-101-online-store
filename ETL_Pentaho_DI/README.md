## Построение ETL процесса в Pentaxo DI.
Главный job, в котором вызывается job загрузки файла, проверка его существования, вызывается трансформация в csv, затем трансформация 
переноса данных в stg слой хранилища, распределение данных по таблицам измерений и создание таблицы фактов.
<p align="center">
      <img src="https://i.ibb.co/TL7TR0W/pent-1.jpg" width="850">
</p>
<hr>
<br>
Job загрузки файла с источника. Реализовано два способа загрузки через HTTP и через скрипт.
<br>
<br>
<p align="center">
      <img src="https://i.ibb.co/H7PNtjC/pent-2.jpg" width="550">
</p>
<hr>
<br>
Трансформация exel файла, состоященго из трех листов, в единый csv фаил.
<br>
<br>
<p align="center">
      <img src="https://i.ibb.co/G2kC9br/pent-3.jpg" width="850">
</p>
<hr>
<br>
Трансформация переноса из csv в stg таблицу хранилища данных с последующим вызовом скрипта, исправляющего недопустимые Null значения.
<br>
<br>
<p align="center">
      <img src="https://i.ibb.co/CQQ72NF/pent-4.jpg" width="850">
</p>
<hr>
<br>
Трансформация переноса данных из stg таблицы в таблицы измерений,c устранением дублей и генерацией искуственных PK.
<br>
<br>
<p align="center">
      <img src="https://i.ibb.co/t8dpKCV/pent-5.jpg" width="850">
</p>
<hr>
<br>
В завершающем шаге ставим главный job на расписание с помощью bat файла и планировщика задач.
<br>
<br>
<p align="center">
      <img src="https://i.ibb.co/7xDh2Mb/pent-6.jpg" width="850">
</p>




