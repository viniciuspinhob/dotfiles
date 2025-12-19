# Gruvbox Dark colorscheme for ranger
# Based on gruvbox dark theme colors

from ranger.gui.color import *
from ranger.colorschemes.default import Default


class Scheme(Default):
    progress_bar_color = 106  # green (gruvbox green)

    def use(self, context):
        fg, bg, attr = Default.use(self, context)

        if context.reset:
            return (fg, bg, attr)

        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            if context.empty or context.error:
                bg = 235  # gruvbox bg0 (darker)
            if context.border:
                fg = 235  # gruvbox bg0
            if context.media:
                if context.image:
                    fg = 106  # gruvbox green
                else:
                    fg = 172  # gruvbox orange
            if context.container:
                fg = 172  # gruvbox orange
            if context.directory:
                # Coluna principal (ativa) fica amarela para destacar
                if context.main_column:
                    fg = 214  # gruvbox bright yellow
                else:
                    fg = 109  # gruvbox blue
            elif context.executable and not \
                    any((context.media, context.container,
                         context.fifo, context.socket)):
                fg = 142  # gruvbox green
            if context.socket:
                fg = 172  # gruvbox orange
                attr |= bold
            if context.fifo:
                fg = 172  # gruvbox orange
            if context.device:
                fg = 172  # gruvbox orange
            if context.link:
                fg = 109 if context.good else 124  # gruvbox blue or red
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (109, 106):  # blue or green
                    fg = 142  # gruvbox green
                else:
                    fg = 142  # gruvbox green
            if not context.selected and (context.cut or context.copied):
                fg = 235  # gruvbox bg0
                attr |= bold
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    # Preserva amarelo para diretórios na coluna principal
                    if not context.directory:
                        fg = 142  # gruvbox green
            if context.badinfo:
                if attr & reverse:
                    bg = 124  # gruvbox red
                else:
                    fg = 124  # gruvbox red

        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = 142 if context.bad else 106  # gruvbox green
            elif context.directory:
                fg = 109  # gruvbox blue
            elif context.tab:
                if context.good:
                    bg = 106  # gruvbox green
            elif context.link:
                fg = 109  # gruvbox blue

        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 142  # gruvbox green
                elif context.bad:
                    fg = 124  # gruvbox red
            if context.marked:
                attr |= bold | reverse
                fg = 142  # gruvbox green
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = 124  # gruvbox red
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = 109  # gruvbox blue
                attr &= ~bold
            if context.vcscommit:
                fg = 142  # gruvbox green
                attr &= ~bold

        if context.text:
            if context.highlight:
                attr |= reverse

        if context.in_taskview:
            if context.title:
                fg = 109  # gruvbox blue

            if context.selected:
                attr |= bold

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = 124  # gruvbox red
            elif context.vcschanged:
                fg = 172  # gruvbox orange
            elif context.vcsunknown:
                fg = 142  # gruvbox green
            elif context.vcsstaged:
                fg = 142  # gruvbox green
                attr |= bold
            elif context.vcssync:
                fg = 142  # gruvbox green
            elif context.vcsbehind:
                fg = 172  # gruvbox orange
            elif context.vcsahead:
                fg = 109  # gruvbox blue
            elif context.vcsdiverged:
                fg = 124  # gruvbox red
                attr |= bold
            elif context.vcsnone:
                fg = 246  # gruvbox gray
            else:
                fg = 246  # gruvbox gray
        elif context.vcsfile and context.selected:
            attr &= ~bold
            if context.vcsconflict:
                fg = 124  # gruvbox red
            elif context.vcschanged:
                fg = 172  # gruvbox orange
            elif context.vcsunknown:
                fg = 142  # gruvbox green
            elif context.vcsstaged:
                fg = 142  # gruvbox green
                attr |= bold
            elif context.vcssync:
                fg = 142  # gruvbox green
            elif context.vcsbehind:
                fg = 172  # gruvbox orange
            elif context.vcsahead:
                fg = 109  # gruvbox blue
            elif context.vcsdiverged:
                fg = 124  # gruvbox red
                attr |= bold
            elif context.vcsnone:
                fg = 246  # gruvbox gray
            else:
                fg = 246  # gruvbox gray

        return (fg, bg, attr)
