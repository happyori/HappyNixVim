{
  plugins.mini = {
    enable = true;
    modules = {
      bufremove = { };
      hipatterns = { };
    };
  };

  extraConfigLua = builtins.readFile ../lua/mini-ai.lua;
}
