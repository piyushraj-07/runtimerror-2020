# Generated by Django 3.1.4 on 2020-12-04 11:20

from django.conf import settings
import django.contrib.auth.models
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('core', '0013_course'),
    ]

    operations = [
        migrations.AddField(
            model_name='user_type',
            name='courses',
            field=models.ManyToManyField(to='core.Course'),
        ),
        migrations.AlterField(
            model_name='course',
            name='code',
            field=models.CharField(max_length=6, verbose_name=django.contrib.auth.models.User),
        ),
        migrations.AlterField(
            model_name='course',
            name='instructors',
            field=models.ManyToManyField(related_name='instrictors', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterField(
            model_name='course',
            name='students',
            field=models.ManyToManyField(related_name='students', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterField(
            model_name='course',
            name='tas',
            field=models.ManyToManyField(related_name='Tas', to=settings.AUTH_USER_MODEL),
        ),
    ]
