#include <gtk/gtk.h>

int main(int argc, char **argv)
{
  gtk_init(&argc, &argv);

  // Set the icon for the window (example with the 128x128 icon)
  GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_icon_from_file(GTK_WINDOW(window), "assets/icons/app_icon_128.png", NULL);

  // Initialize Flutter engine and run the application
  // (Rest of your Flutter initialization code)

  return 0;
}
